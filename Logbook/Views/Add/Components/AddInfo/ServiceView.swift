//
//  ServiceView.swift
//  Logbook
//
//  Created by Thomas Nürk on 31.12.23.
//

import SwiftUI

struct ServiceView: View {
    
    @State var price = 0
    @State var message = ""
    
    @Binding var newLogbook: LogbookEntry
    @Binding var selection: Int
    @Binding var showSheet: Bool
    @Binding var showAddInfoSelection: Bool
    
    var numberFormatter: NumberFormatterProtocol = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    var isSubmittable: Bool {
        price != 0  && !message.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            AlternativeCloseButton {
                    if(!isSubmittable) {
                        newLogbook.service = nil
                    }
                    selection = -1
                    showSheet.toggle()
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
                
                TextEditor(text: $message)
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
                    .padding(.bottom, 20)
                
                    Button {
                        newLogbook.service?.price = Double(price) / 100
                        newLogbook.service?.message = message
                        showAddInfoSelection.toggle()
                    } label: {
                        HStack {
                            Image(systemName: "arrow.right")
                            Text("Übernehmen")
                                .customFont(.headline)
                        }
                        .largeButton(disabled: !isSubmittable)
                    }
                    .disabled(!isSubmittable)
                
            }
            .padding(20)
            .onAppear {
                if(newLogbook.service == nil) {
                    newLogbook.service = Service()
                }
            }
        }
    }
}


#Preview {
    ServiceView(newLogbook: .constant(LogbookEntry.previewData.data[0]), selection: .constant(-1), showSheet: .constant(false), showAddInfoSelection: .constant(false))
}
