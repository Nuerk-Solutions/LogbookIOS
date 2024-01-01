//
//  MileAgeCurrent.swift
//  Logbook
//
//  Created by Thomas Nürk on 01.01.24.
//

import SwiftUI

struct MileAgeComponent: View {
    
    @Binding var newLogbook: LogbookEntry
    @State private var reason: String = ""
    
    var body: some View {
            VStack(spacing: 8) {
                VStack(alignment: .leading, spacing: 3) {
                    Text(newLogbook.vehicle == .MX5 ? "Aktueller Meilenstand" : "Aktueller Kilometerstand")
                        .customFont(.subheadline)
                        .foregroundColor(.secondary)
                    TextField("", value: $newLogbook.mileAge.current, format: .number)
                    //                    .addDoneButtonOnKeyboard()
                        .customTextField(image: Image(systemName: "car.fill"), suffix: newLogbook.mileAge.unit)
                        .keyboardType(.decimalPad)
                        .submitLabel(.done)
                        .opacity(0.4)
                        .disabled(true)
                    
                    Text(newLogbook.vehicle == .MX5 ? "Neuer Meilenstand" : "Neuer Kilometerstand")
                        .customFont(.subheadline)
                        .foregroundColor(.secondary)
                    TextField("", value: $newLogbook.mileAge.new, format: .number)
                    //                    .addDoneButtonOnKeyboard()
                        .customTextField(image: Image(systemName: "car.2.fill"), suffix: newLogbook.mileAge.unit)
                        .keyboardType(.decimalPad)
                        .submitLabel(.done)
                    
                    Text("Reiseziel")
                        .customFont(.subheadline)
                        .foregroundColor(.secondary)
                    TextField("", text: $newLogbook.reason)
                    //                    .addDoneButtonOnKeyboard()
                        .customTextField(image: Image(systemName: "scope"))
                        .introspectTextField(customize: {
                            $0.clearButtonMode = .whileEditing
                        })
                }
                .toolbar {
                    ToolbarItem(placement: .keyboard) {
                        HStack {
                            Spacer()
                            Button("Fertig") {
                                hideKeyboard()
                            }
                        }
                    }
                }
            }
    }
}

#Preview {
    MileAgeComponent(newLogbook: .constant(LogbookEntry.previewData.data[0]))
}
