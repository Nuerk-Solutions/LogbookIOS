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
            }
        } catch {
            print(error)
            if Task.isCancelled { return }
        }
        
    }
    
    
    func animateGraph(fromChange: Bool = false) {
        for(index, _) in logbooks.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * (fromChange ? 0.03 : 0.05)) { [self] in
                withAnimation(fromChange ? .easeInOut(duration: 0.5) : .interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)) {
                    logbooks[index].animated = true
                }
            }
        }
    }
    
}
