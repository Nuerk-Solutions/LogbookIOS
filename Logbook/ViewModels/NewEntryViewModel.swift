//
//  NewEntryViewModel.swift
//  Logbook
//
//  Created by Thomas on 29.07.22.
//

import Foundation
import SwiftUI

@MainActor
class NewEntryViewModel: ObservableObject {
    
    @Published var newLogbook: LogbookEntry = LogbookEntry()
    @Published var fetchPhase = DataFetchPhase<[LogbookEntry]>.empty
    @Published var sendPhase = DataSendPhase<LogbookEntry>.empty
    @Published var fetchTaskToken: FetchTaskToken
    
    private let cache = DiskCache<[LogbookEntry]>(filename: "xca_last_entries", expirationInterval: 30 * 60 * 60 * 24)
    private let logbookAPI = LogbookAPI.shared
    
    
    init(lastEntries: [LogbookEntry]? = nil) {
        if let lastEntries = lastEntries {
            self.fetchPhase = .success(lastEntries)
        } else {
            self.fetchPhase = .empty
        }
        self.fetchTaskToken = FetchTaskToken(fetchCategory: .latest, token: Date())
        
        Task(priority: .userInitiated) {
            try? await cache.loadFromDisk()
        }
    }
    
    func load(forceFetching: Bool = false) async {
        if Task.isCancelled { return }
        
        if !forceFetching || !NetworkReachability.shared.reachable {
            if let lastLogbooks = await cache.value(forKey: "last") {
                print("[NewEntry]: CACHE HIT for last value")
                withAnimation {
                    fetchPhase = !NetworkReachability.shared.reachable ? .success(lastLogbooks) : .fetchingNextPage(lastLogbooks)
                }
            }
        }
        
        

        if !NetworkReachability.shared.reachable {
            print("[NewEntry]: No network connection")
            print("[NewEntr]: 🛑 Prevent API request...")
            return
        }
        
        do {
            let lastFetchedLogbooks = try await logbookAPI.fetchLast()
            
            if Task.isCancelled { return }
            
            await cache.setValue(lastFetchedLogbooks.data, forKey: "last")
            try? await cache.saveToDisk()
            
            print("[NewEntry]: Fetched last logbooks")
            print("[NewEntry]: Count of \(lastFetchedLogbooks.length)")
            
            withAnimation {
                fetchPhase = .success(lastFetchedLogbooks.data )
                self.fetchTaskToken = FetchTaskToken(fetchCategory: .latest, token: Date())
            }
            
        } catch {
            print(error)
            if Task.isCancelled { return }
            
            withAnimation {
                fetchPhase = .failure(error)
            }
        }
    }
    
    private func sendBody() async {
        do {
            
            // Workaround for different savings
        
            // MARK: TODO: Check and implement the comment below for , or .
            
//            newLogbook.additionalInformationCost = newLogbook.additionalInformationCost.replacingOccurrences(of: ",", with: ".")
//            if newLogbook.additionalInformationTyp == .Getankt {
//                newLogbook.additionalInformation = newLogbook.additionalInformation.replacingOccurrences(of: ",", with: ".")
//                newLogbook.additionalInformationTyp = .Getankt
//            }
            
            let submittedLogbook = try await logbookAPI.send(with: newLogbook)
            if Task.isCancelled { return }
            
            sendPhase = .success(submittedLogbook)
//            sendPhase = .success
        } catch {
            if Task.isCancelled { return }

            withAnimation {
                sendPhase = .failure(error)
            }
        }
    }
    
    func send() async {
        if Task.isCancelled { return }
        
        withAnimation {
            sendPhase = .sending
        }
        await sendBody()
    }
}
