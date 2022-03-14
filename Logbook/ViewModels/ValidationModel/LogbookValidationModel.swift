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
    
    func saveEntry(logbookEntry: LogbookModel) {
        if(validate(viewState: logbookEntry)) {
            // save the entry
        }
    }
    
    private func validate(viewState: LogbookModel) -> Bool {
        brokenValues.removeAll()
        
        let currentMileAge: Int = Int(viewState.currentMileAge) ?? 0
        let newMileAge: Int = Int(viewState.newMileAge) ?? 0
        
        if(viewState.driveReason.isEmpty) {
            brokenValues.append(BrokenValue(message: "Das Reisziel darf nicht leer sein!"))
        }
        if(viewState.currentMileAge.isEmpty) {
            brokenValues.append(BrokenValue(message: "Der aktuelle Kilometerstand darf nicht leer sein!"))
        }
        if(viewState.newMileAge.isEmpty) {
            brokenValues.append(BrokenValue(message: "Der neue Kilometerstand darf nicht leer sein!"))
        }
        
        if(newMileAge < currentMileAge) {
            brokenValues.append(BrokenValue(message: "Der neue Kilometerstand darf nicht kleiner als der aktuelle sein!"))
        }
        if(newMileAge == currentMileAge) {
            brokenValues.append(BrokenValue(message: "Der neue Kilometerstand darf nicht dem aktuellem entsprechen!"))
        }
        if(viewState.additionalInformationTyp != .Keine) {
            if(viewState.additionalInformationTyp == .Getankt) {
                if(viewState.additionalInformation.isEmpty || !viewState.additionalInformation.isDouble()) {
                    brokenValues.append(BrokenValue(message: "Fehlerhafte Tankmenge!"))
                }
                if(viewState.additionalInformationCost.isEmpty || !viewState.additionalInformationCost.isDouble()) {
                    brokenValues.append(BrokenValue(message: "Fehlerhafte Kosten!"))
                }
            }
            if(viewState.additionalInformationTyp == .Gewartet) {
                if(viewState.additionalInformation.isEmpty) {
                    brokenValues.append(BrokenValue(message: "Fehlerhafte Beschreibung!"))
                }
                if(viewState.additionalInformationCost.isEmpty || !viewState.additionalInformationCost.isDouble()) {
                    brokenValues.append(BrokenValue(message: "Fehlerhafte Kosten!"))
                }
            }
        }
        return brokenValues.count == 0
    }
    
}
