//
//  LogbookListViewModel.swift
//  Logbook
//
//  Created by Thomas on 05.01.22.
//

import Foundation
import SwiftUI
import Alamofire
import Combine
class ListViewModel: ObservableObject {
    
    @Published var originalLogbooks = [LogbookModel]()
    @Published var logbooks = [LogbookModel]()
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var errorMessage: String?
    @Published var searchTerm: String = ""
    
    @Published var isLoadingPage = false
    private var canLoadMorePages = true
    
    @Published var logbookListFull = false
    var currentPage = 0
    let perPage = 25
    
    
    let session: Session
    let interceptor: RequestInterceptor = Interceptor()
    
    
    init() {
        session = Session(interceptor: interceptor)
        //        Task {
        loadMoreContent()
        //        }
        //        withAnimation {
        //            Publishers.CombineLatest($originalLogbooks, $searchTerm)
        //                .map { logbooks, searchTerm in
        //                    logbooks.filter { logbook in
        //                        searchTerm.isEmpty ? true : (logbook.driveReason.contains(searchTerm) || logbook.driver.id.contains(searchTerm))
        //                    }
        //                }
        //                .debounce(for: .seconds(1), scheduler: RunLoop.main)
        //                .assign(to: &$logbooks)
        //        }
    }
    
    func loadMoreContentIfNeeded(currentItem item: LogbookModel?) {
        guard let item = item else {
            loadMoreContent()
            return
        }
        
        let thresholdIndex = originalLogbooks.index(originalLogbooks.endIndex, offsetBy: -5)
        if originalLogbooks.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
            loadMoreContent()
        }
    }
    
    func refresh(afterNewEntry: Bool = false) {
        withAnimation {
            self.currentPage = 0
            self.canLoadMorePages = true
            if !afterNewEntry {
                self.originalLogbooks.removeAll()
            }
            self.loadMoreContent(afterNewEntry: afterNewEntry)
        }
    }
    
    
    private func loadMoreContent(afterNewEntry: Bool = false) {
        guard !isLoadingPage && canLoadMorePages else {
            return
        }
        isLoadingPage = true
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.standardT)
        let url = "https://europe-west1-logbookbackend.cloudfunctions.net/api/logbook/find/all?sort=-date&page=\(currentPage)&limit=\(perPage)"
        session.request(url, method: .get)
            .validate(statusCode: 200..<201)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case.failure(let error):
                    switch response.response?.statusCode {
                    default:
                        self.errorMessage = error.localizedDescription
                        self.showAlert = true
                        self.isLoading = false
                        printError(description: "Pagination fetch more content", errorMessage: error.errorDescription)
                        break
                    }
                    print(error)
                case.success(_):
                    consoleManager.print("Feteched entries (\(self.currentPage) \(self.canLoadMorePages)")
                    withAnimation {
                        self.isLoading = false
                    }
                    break
                }
            }
            .publishDecodable(type: [LogbookModel].self, decoder: decoder)
            .tryMap {$0.value}
            .receive(on: RunLoop.main)
            .handleEvents(receiveOutput: { response in
                self.canLoadMorePages = response?.count == self.perPage
                self.isLoadingPage = false
                self.currentPage += 1
            })
            .map({ response in
                consoleManager.print("Mapped items")
                withAnimation {
                    if !afterNewEntry {
                        self.originalLogbooks.append(contentsOf: response ?? [])
                    } else {
                        self.originalLogbooks = response ?? []
                    }
                }
                return self.originalLogbooks
            })
            .catch ({ _ in Just(self.originalLogbooks)})
                .assign(to: &$originalLogbooks)
    }
}
