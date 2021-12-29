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
            brokenValues.append(BrokenValue(message: "Der neue Kilometerstand darf nicht kleiner als der aktuelle sein!"))
        }
        if(viewState.additionalInformation?.informationTyp != AdditionalInformationEnum.none) {
            if(viewState.additionalInformation?.informationTyp == .refuled) {
                if(viewState.additionalInformation!.information.isEmpty || !viewState.additionalInformation!.information.isDouble()) {
                    brokenValues.append(BrokenValue(message: "Fehlerhafte Tankmenge!"))
                }
                if(viewState.additionalInformation!.cost.isEmpty || !viewState.additionalInformation!.cost.isDouble()) {
                    brokenValues.append(BrokenValue(message: "Fehlerhafte Kosten!"))
                }
            }
            if(viewState.additionalInformation?.informationTyp == .service) {
                if(viewState.additionalInformation!.information.isEmpty) {
                    brokenValues.append(BrokenValue(message: "Fehlerhafte Beschreibung!"))
                }
                if(viewState.additionalInformation!.cost.isEmpty || !viewState.additionalInformation!.cost.isDouble()) {
                    brokenValues.append(BrokenValue(message: "Fehlerhafte Kosten!"))
                }
            }
        }
        return brokenValues.count == 0
    }
    
}
