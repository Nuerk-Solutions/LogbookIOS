//
//  EntrySubmitComponent.swift
//  Logbook
//
//  Created by Thomas Nürk on 01.01.24.
//

import SwiftUI
import AlertKit

struct EntrySubmitComponent: View {
    @EnvironmentObject var newEntryVM: NewEntryViewModel
    @EnvironmentObject var networkReachablility: NetworkReachability
    
    var body: some View {
        if(newEntryVM.newLogbook.isSubmittable) {
            Text("Zusammenfassung: \(String(format: "%.0f\(newEntryVM.newLogbook.mileAge.unit.name)", newEntryVM.newLogbook.distance)) / \((newEntryVM.newLogbook.computedDistance * 0.2).formatted(.currency(code: "EUR")))")
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
        } else {
            Text("Bitte überprüfe deine Angaben!")
        }
        VStack {
            Spacer()
            
            Button {
                if !newEntryVM.newLogbook.isSubmittable {
                    return
                }
                
                Task {
                    await newEntryVM.send(connected: networkReachablility.connected)
                }
            } label: {
                HStack {
                    Image(systemName: "arrow.right")
                    Text("Fahrt hinzufügen")
                        .customFont(.headline)
                }
                .largeButton(disabled: !newEntryVM.newLogbook.isSubmittable)
            }
            .opacity(!newEntryVM.newLogbook.isSubmittable ? 0.4 : 1)
            .transition(.identity)
            .disabled(!newEntryVM.newLogbook.isSubmittable)
            //                Spacer()
        }
    }
}

#Preview {
    EntrySubmitComponent()
}
