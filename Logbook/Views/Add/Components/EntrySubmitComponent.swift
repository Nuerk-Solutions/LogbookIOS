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
            HStack (spacing: 2) {
                Image(systemName: "sum")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 15, height: 15)
                Text("\(String(format: "%.0f\(newEntryVM.newLogbook.mileAge.unit.name)", newEntryVM.newLogbook.distance)) / \((newEntryVM.newLogbook.computedDistance * 0.2).formatted(.currency(code: "EUR")))")
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        } else {
            Text("Bitte überprüfe deine Angaben!")
        }
        VStack {
            Button {
                if !newEntryVM.newLogbook.isSubmittable {
                    return
                }
                
                Task {
                    await newEntryVM.send()
                }
            } label: {
                HStack {
                    Image(systemName: "arrow.right")
                    Text("Fahrt hinzufügen")
                        .font(.headline)
                }
                .largeButton(disabled: !newEntryVM.newLogbook.isSubmittable)
            }
            .opacity(!newEntryVM.newLogbook.isSubmittable ? 0.4 : 1)
            .transition(.identity)
            .disabled(!newEntryVM.newLogbook.isSubmittable)
        }
    }
}

#Preview {
    EntrySubmitComponent()
}
