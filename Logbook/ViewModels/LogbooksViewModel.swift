//
//  LogbooksViewModel.swift
//  Logbook
//
//  Created by Thomas on 26.05.22.
//

import Foundation
import SwiftUI
import Alamofire

@MainActor
class LogbooksViewModel: ObservableObject {
    
    @EnvironmentObject var model: Model
    @Published var phase = DataFetchPhase<[LogbookEntry]>.empty
    @Published var loadedLogbooks: [LogbookEntry] = []
    @Published var logbooksOpacity: Double = 1
    @AppStorage("lastListRefresh") var lastListRefresh: Int = -1
    private let cache = DiskCache<[LogbookEntry]>(filename: "xca_list_entries", expirationInterval: 30 * 60 * 60 * 24)
    private let logbookAPI = LogbookAPI.shared
    private let pagingData = PagingData(itemsPerPage: 25, maxPageLimit: 999) // TODO: May rethink this decission
    
    private var page = 0
    private let limit = 25
    private var canLoadMorePages = true
    
    var lastRefreshedDateText: String {
        if lastListRefresh != -1 {
            return "Letzte Aktualisierung: \(DateFormatter.readableDeShort.string(from: Date(timeIntervalSince1970: TimeInterval(lastListRefresh))))"
        } else {
            return "Warten..."
        }
    }
    
    var logbooks: [LogbookEntry] {
        phase.value ?? []
    }
    
    var isFetchingNextPage: Bool {
        if case .fetchingNextPage = phase {
            return true
        }
        return false
    }
    
    init(logbooks: [LogbookEntry]? = nil) {
        if let logbooks = logbooks {
            self.phase = .success(logbooks)
        } else {
            self.phase = .empty
        }
//        self.lastListRefresh = Int(Date().timeIntervalSince1970)
//        self.fetchTaskToken = FetchTaskToken(fetchCategory: .list, token: Date())
        
        Task(priority: .userInitiated) {
            try? await cache.loadFromDisk()
        }
    }
    
    func deleteEntry(connected: Bool, logbook: LogbookEntry) async {
        if Task.isCancelled { return }
        
        if !connected {
            print("[Deleting]: No network connection")
            print("[Deleting]: 🛑 Prevent API request...")
            return
        }
        
        logbookAPI.delete(with: logbook)
        
    }
    func refreshTask() async {
        //        Task {
        await pagingData.reset()
        await cache.removeValue(forKey: "\(pagingData.currentPage)")
        self.lastListRefresh = Int(Date().timeIntervalSince1970)
//        self.fetchTaskToken.token = Date()
        //        }
    }
    
    func combine<T>(_ arrays: Array<T>?...) -> Set<T> {
        return arrays.compactMap{$0}.compactMap{Set($0)}.reduce(Set<T>()){$0.union($1)}
    }
    
    func loadFirstPage(connected: Bool) async {
        if Task.isCancelled { return }
        
        if let nextLogbooks = await nextLogbooksFromCache(), !nextLogbooks.isEmpty {
            withAnimation {
                self.phase = .success(nextLogbooks)
                loadedLogbooks = nextLogbooks
            }
        }

        if !connected {
            print("[Paging]: No network connection")
            print("[Paging]: 🛑 Prevent API request...")
            return
        }
        
//        withAnimation {
//            phase = .empty
//        }
        
        do {
            await pagingData.reset()

            let logbooks = try await pagingData.loadNextPage(dataFetchProvider: loadLogbooks(page:))

//            if logbooks.isEmpty || loadedLogbooks.elementsEqual(logbooks, by: { entry, entry2 in
//                entry._id == entry2._id
//            }) {
//                withAnimation {
//                    phase = .success(loadedLogbooks)
//                }
//                return
//            }
            await cache.setValue(logbooks, forKey: "\(pagingData.currentPage)")
            try? await cache.saveToDisk()
            
//            self.lastListRefresh = Int(Date().timeIntervalSince1970)

            if Task.isCancelled { return }
            
            var cacheHasChanged = false
            if(!logbooks.isEmpty) {
                cacheHasChanged = loadedLogbooks.first?._id != logbooks.first?._id
            }
            print("CACHE CHANGED: \(cacheHasChanged)")
//            loadedLogbooks = logbooks
            
//            let newArray = combine(logbooks, loadedLogbooks)
            
            if cacheHasChanged {
                withAnimation {
                    loadedLogbooks = logbooks
                    phase = .success(logbooks)
                }
                return
            }
        } catch {
            if Task.isCancelled { return }

            withAnimation {
                phase = .failure(error)
            }
        }
    }
    
    func loadNextPage() async {
        if Task.isCancelled {  return }
        
        var logbooks = self.phase.value ?? []
        withAnimation {
            phase = .fetchingNextPage(logbooks)
        }
        
        if let nextLogbooks = await nextLogbooksFromCache(), !nextLogbooks.isEmpty {
            withAnimation {
                phase = .success(nextLogbooks)
            }
            loadedLogbooks = self.phase.value!
            return
        }
        
//        phase = .empty
        
        do {
            let nextLogbooks = try await pagingData.loadNextPage(dataFetchProvider: loadLogbooks(page:))
            if Task.isCancelled { return }
            
            logbooks.append(contentsOf: nextLogbooks)
            
            await cache.setValue(nextLogbooks, forKey: "\(pagingData.currentPage)")
            try? await cache.saveToDisk()
            
            withAnimation {
                phase = .success(logbooks)
            }
            
            loadedLogbooks = self.phase.value!
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func nextLogbooksFromCache() async -> [LogbookEntry]? {
        var logbooks = self.phase.value ?? []
        if let nextLogbooks = try? await pagingData.loadNextPage(dataFetchProvider: loadLogbooksFromCache(page:)), !nextLogbooks.isEmpty {
            logbooks += nextLogbooks
            return logbooks
        }
        return []
    }
    
    private func loadLogbooksFromCache(page: Int) async throws -> [LogbookEntry] {
        if let logbooks = await cache.value(forKey: "\(page)") {
            if Task.isCancelled { return [] }
            await print("[Paging]: Cache HIT for page \(pagingData.currentPage) (\(page)), maxPageLimit: \(pagingData.maxPageLimit), size: \(logbooks.count)")
            return logbooks
        }
        return []
    }
    
    private func loadLogbooks(page: Int) async throws -> [LogbookEntry] {
        let logbooks = try await logbookAPI.fetch(with: LogbookRequestParameters(page: page, limit: pagingData.itemsPerPage))
        if Task.isCancelled {  return [] }
        await print("[Paging]: Cache EXPIRED for page \(pagingData.currentPage) (\(page)), maxPageLimit: \(pagingData.maxPageLimit), size: \(logbooks.length)")
        print("[Paging]: 🚀 Making request...")
        return logbooks.data ?? []
    }
}


struct FetchTaskToken: Equatable {
    var fetchCategory: FetchCategory
    var token: Date
}

enum FetchCategory: String {
    case list
    case latest
    case driverStats
    case vehicleStats
}

extension Array where Element: Hashable {
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}
