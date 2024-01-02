//
//  EntrySubmitComponent.swift
//  Logbook
//
//  Created by Thomas Nürk on 01.01.24.
//

import SwiftUI

struct EntrySubmitComponent: View {
    @Binding var newLogbook: LogbookEntry
    
    var body: some View {
        if(newLogbook.isSubmittable) {
            Text("Zusammenfassung: \(String(format: "%.0f\(newLogbook.mileAge.unit.name)", newLogbook.distance)) / \((newLogbook.computedDistance * 0.2).formatted(.currency(code: "EUR")))")
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
        } else {
            Text("Bitte überprüfe deine Angaben!")
        }
        VStack {
            Spacer()
            
            Button {
                if !newLogbook.isSubmittable {
                    return
                }
            } label: {
                HStack {
                    Image(systemName: "arrow.right")
                    Text("Fahrt hinzufügen")
                        .customFont(.headline)
                }
                .largeButton(disabled: !newLogbook.isSubmittable)
            }
            .opacity(!newLogbook.isSubmittable ? 0 : 1)
            .transition(.identity)
            .disabled(!newLogbook.isSubmittable)
            //                Spacer()
        }
    }
}

#Preview {
    EntrySubmitComponent(newLogbook: .constant(LogbookEntry.previewData.data[0]))
}
