//
//  MileAgeCurrent.swift
//  Logbook
//
//  Created by Thomas Nürk on 01.01.24.
//

import SwiftUI
import SwiftUIIntrospect

struct MileAgeComponent: View {
    
    @Binding var newLogbook: LogbookEntry
    @State private var showSeperator: Bool = false
    @State private var test = 0
    @State private var scrollViewOffset: CGFloat = 0
    
    let numberFormatterNoGroup: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.zeroSymbol = ""
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = false
        return formatter
    }()
    
    let numberFormatterWGroup: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.zeroSymbol = ""
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = true
        return formatter
    }()
    
    var body: some View {
            VStack(spacing: 8) {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Aktueller \(newLogbook.mileAge.unit.fullName)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    TextField("", value: $newLogbook.mileAge.current, format: .number)
                        .customTextField(image: Image(systemName: "car.fill"), suffix: newLogbook.mileAge.unit.name)
                        .keyboardType(.decimalPad)
                        .submitLabel(.done)
                        .opacity(0.4)
                        .disabled(true)
                    
                    Text("Neuer \(newLogbook.mileAge.unit.fullName)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    TextField("", value: $newLogbook.mileAge.new, formatter: showSeperator ? numberFormatterWGroup : numberFormatterNoGroup, onEditingChanged: { isEdit in
                        showSeperator = !isEdit
                    })
                    .addDoneButtonOnKeyboard()
                    .customTextField(image: Image(systemName: "car.2.fill"), suffix: newLogbook.mileAge.unit.name)
                    .keyboardType(.decimalPad)
                    .submitLabel(.done)
                    
                    Text("Reiseziel")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    TextField("", text: $newLogbook.reason)
                        .addDoneButtonOnKeyboard()
                        .customTextField(image: Image(systemName: "house.and.flag"))
                        .introspect(.textField, on: .iOS(.v15, .v16, .v17), customize: { view in
                            view.clearButtonMode = .whileEditing
                        })
                        .submitLabel(.done)
                }
            }
    }
    
}

#Preview {
    MileAgeComponent(newLogbook: .constant(LogbookEntry(mileAge: MileAge(current: 14874, new: 0))))
}
