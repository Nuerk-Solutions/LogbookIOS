//
//  ChartViewModel.swift
//  Logbook
//
//  Created by Thomas on 22.11.22.
//

import Foundation


@MainActor
class ChartViewModel: ObservableObject {
    
    @Published var allLogbooks: [LogbookRefuelReceive] = []
    private let logbookAPI = LogbookAPI.shared
    
    func loadLogbooks() async {
        if Task.isCancelled { return }
        
        do {
            allLogbooks = try await logbookAPI.fetchRefuels(with: 10)
        } catch {
            print(error)
            if Task.isCancelled { return }
        }
        
    }
    
}
