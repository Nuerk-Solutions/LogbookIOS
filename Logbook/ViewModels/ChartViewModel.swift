//
//  ChartViewModel.swift
//  Logbook
//
//  Created by Thomas on 22.11.22.
//

import Foundation
import SwiftUI

@MainActor
class ChartViewModel: ObservableObject {
    
    @Published var allLogbooks: [LogbookEntry] = []
    @Published var logbooks: [LogbookEntry] = []
//    @Published var selectedVehicles: [VehicleEnum] = [.Ferrari]
    private let logbookAPI = LogbookAPI.shared
    
    func updateLogbooks(for vehicles: [VehicleEnum]) {
        resetAnimation()
        logbooks = allLogbooks.filter({ item in
            vehicles.contains(item.vehicle)
        })
    }
    
    private func resetAnimation() {
        for(index, _) in allLogbooks.enumerated() {
            allLogbooks[index].animated = false
        }
    }
    
    func loadLogbooks() async {
        if Task.isCancelled { return }
        
        do {
            let result = try await logbookAPI.fetchRefuels(with: 8)

            withAnimation {
                allLogbooks = result
                updateLogbooks(for: [.Ferrari])
                print(logbooks[0])
            }
        } catch {
            print(error)
            if Task.isCancelled { return }
        }
        
    }
    
}
