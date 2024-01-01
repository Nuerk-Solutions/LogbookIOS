//
//  LogbookUtils.swift
//  Logbook
//
//  Created by Thomas Nürk on 01.01.24.
//

import Foundation
import SwiftUI

func getLogbookForVehicle(lastLogbooks: [LogbookEntry], vehicle: VehicleEnum) -> LogbookEntry? {
    lastLogbooks.first { entry in
        entry.vehicle == vehicle
    }
}

extension LogbookEntry {
    
    var isSubmittable: Bool {
        self.mileAge.new > self.mileAge.current && !self.reason.isEmpty
    }
    
    var distance: Double {
        Double(self.mileAge.new - self.mileAge.current)
    }
    
    var hasAddInfo: Bool {
        self.service != nil && self.refuel != nil
    }
    
    
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
