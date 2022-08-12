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
    
    private var offlineRequestManager: OfflineRequestManager {
        return OfflineRequestManager.defaultManager
    }
    
    
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
    
    func load(forceFetching: Bool = false, connected: Bool) async {
        if Task.isCancelled { return }
        
        if !forceFetching || !connected {
            if let lastLogbooks = await cache.value(forKey: "last") {
                print("[NewEntry]: CACHE HIT for last value")
                withAnimation {
                    fetchPhase =  !connected ? .success(lastLogbooks) : .fetchingNextPage(lastLogbooks)
                }
            }
        }
        
        

        if !connected {
            print("[NewEntry]: No network connection")
            print("[NewEntr]: 🛑 Prevent API request...")
            return
        }
        
        do {
            let lastFetchedLogbooks = try await logbookAPI.fetchLast()
            
            if Task.isCancelled { return }
            
            await cache.setValue(lastFetchedLogbooks, forKey: "last")
            try? await cache.saveToDisk()
            
            print("[NewEntry]: Fetched last logbooks")
            print("[NewEntry]: Count of \(lastFetchedLogbooks.count)")
            
            withAnimation {
                fetchPhase = .success(lastFetchedLogbooks)
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
            newLogbook.additionalInformationCost = newLogbook.additionalInformationCost.replacingOccurrences(of: ",", with: ".")
            if newLogbook.additionalInformationTyp == .Getankt {
                newLogbook.additionalInformation = newLogbook.additionalInformation.replacingOccurrences(of: ",", with: ".")
            }
            
            let submittedLogbook = try await logbookAPI.send(with: newLogbook)
            if Task.isCancelled { return }
            
            sendPhase = .success(submittedLogbook)
        } catch {
            if Task.isCancelled { return }

            withAnimation {
                sendPhase = .failure(error)
            }
        }
    }
    
    func send(connected: Bool) async {
        if Task.isCancelled { return }
        
        withAnimation {
            sendPhase = .sending
        }
        
        if !connected {
            offlineRequestManager.queueRequest(AlamonOfflineRequest.newRequest {
                Task {
                    await self.sendBody()
                }
            })
            sendPhase = .success(newLogbook)
            return
        }
        await sendBody()
    }
}
