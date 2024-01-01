//
//  ServiceView.swift
//  Logbook
//
//  Created by Thomas Nürk on 31.12.23.
//

import SwiftUI

struct ServiceView: View {
    
    @State private var logbookEntry: LogbookEntry = LogbookEntry()
    @State private var price = 0
    @State private var message = ""
    @State private var test: String? = "Test"
    @State private var canSubmit: Bool = true
    
    @Binding var selection: Int
    @Binding var showSheet: Bool
    @Binding var showAddInfoSelection: Bool
    
    var numberFormatter: NumberFormatterProtocol = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    var body: some View {
        NavigationStack {
            Button {
                selection = -1
                showSheet.toggle()
            } label: {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .frame(width: 36, height: 36)
                    .background(.black)
                    .mask(Circle())
                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 10)
            }
            .frame(maxWidth: .infinity, alignment: .topTrailing)
            .padding(.trailing, 20)
            
            Text("Wartungsdaten")
                .font(.largeTitle)
                .bold()
            
            VStack(alignment: .leading) {
                Text("Preis")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                CurrencyTextField(numberFormatter: numberFormatter, value: $price)
                    .padding(.horizontal, 10)
                    .customTextField(image: Image(systemName: "eurosign"))
                    .frame(height: 50)
                
                Text("Beschreibung")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                TextEditor(text: $logbookEntry.service.bound.message)
                    .multilineTextAlignment(.leading)
                    .frame(minHeight: 30, maxHeight: 220, alignment: .leading)
                    .scrollContentBackground(.hidden)
                    .customTextArea()
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
                
                    Button {
                        showAddInfoSelection.toggle()
                    } label: {
                        HStack {
                            Image(systemName: "arrow.right")
                            Text("Übernehmen")
                                .customFont(.headline)
                        }
                        .largeButton(disabled: !canSubmit)
                    }
                    .disabled(!canSubmit)
                
            }
            .padding(20)
            .background(.regularMaterial)
        }
    }
}


#Preview {
    ServiceView(selection: .constant(-1), showSheet: .constant(false), showAddInfoSelection: .constant(false))
}
