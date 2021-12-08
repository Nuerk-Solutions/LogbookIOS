//
//  LogbookEntryViewModel.swift
//  Logbook
//
//  Created by Thomas on 08.12.21.
//

import Foundation


struct BrokenValue: Identifiable {
    let id = UUID()
    let message: String
}

class AddLogbookEntryViewModel: ObservableObject {
    
    @Published var brokenValues = [BrokenValue]()
    
    func saveEntry(logbookEntry: Logbook) {
        if(validate(viewState: logbookEntry)) {
            // save the entry
        }
    }
    
    private func validate(viewState: Logbook) -> Bool {
        brokenValues.removeAll()
        if(viewState.driveReason.isEmpty) {
            brokenValues.append(BrokenValue(message: "Das Reisziel darf nicht leer sein!"))
        }
        if(String(viewState.vehicle.currentMileAge).isEmpty) {
            brokenValues.append(BrokenValue(message: "Der aktuelle Kilometerstand darf nicht leer sein!"))
        }
        if(String(viewState.vehicle.newMileAge).isEmpty) {
            brokenValues.append(BrokenValue(message: "Der neue Kilometerstand darf nicht leer sein!"))
        }
        
        if(viewState.vehicle.newMileAge < viewState.vehicle.currentMileAge) {
            brokenValues.append(BrokenValue(message: "Der neue Kilometerstand darf nicht kleiner als der aktuelle Kilometerstand sein!"))
        }
        return brokenValues.count == 0
    }
    
}
