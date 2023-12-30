//
//  ChartViewModel.swift
//  Logbook
//
//  Created by Thomas on 22.11.22.
//

import Foundation


@MainActor
class ChartViewModel: ObservableObject {
    
    @Published var allLogbooks: [LogbookEntry] = []
    @Published var filteredLogbooks: [LogbookEntry] = []
    private let logbookAPI = LogbookAPI.shared
    
    func loadLogbooks() async {
        if Task.isCancelled { return }
        
//        if !connected {
//            print("[Deleting]: No network connection")
//            print("[Deleting]: 🛑 Prevent API request...")
//            return
//        }
        do {
            allLogbooks = try await logbookAPI.fetch(with: LogbookRequestParameters(page: 0, limit: 0)).data ?? []
        } catch {
                print(error)
                if Task.isCancelled { return }
        }
        
    }
    
}
