//
//  RefuelView.swift
//  Logbook
//
//  Created by Thomas Nürk on 31.12.23.
//

import SwiftUI

struct RefuelView: View {
    
    @State private var logbookEntry: LogbookEntry = LogbookEntry()    
    @State var price = 0
    @State var liters = 0
    @State var isSpecial: Bool = false
    @State var canSubmit: Bool = true
    
    @Binding var showAddInfoSelection: Bool
    @Binding var showSheet: Bool
    @Binding var selection: Int
    
    var numberFormatter: NumberFormatterProtocol = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    var body: some View {
        VStack {
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
            
            Text("Tankdaten")
                .font(.largeTitle)
                .bold()
            
            VStack(alignment: .leading) {
                Text("Menge")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                MassTextField(value: $liters)
                    .padding(.horizontal, 10)
                    .customTextField(image: Image(systemName: "eurosign"))
                    .frame(height: 50)
                
                Text("Preis")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                CurrencyTextField(numberFormatter: numberFormatter, value: $price)
                    .padding(.horizontal, 10)
                    .customTextField(image: Image(systemName: "flame"))
                    .frame(height: 50)
//                    .overlay(RoundedRectangle(cornerRadius: 16)
//                                .stroke(Color.gray.opacity(0.3), lineWidth: 2))
                
                Text("Preis pro Liter: \(numberFormatter.string(for: Double(price) / Double(liters)) ?? "0.00€")")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                
                Toggle(isOn: $isSpecial) {
                    Text("Keine Volltankung")
                }
                .padding(.top, 10)
                .padding(.bottom, 20)
                
                Button {
                    showAddInfoSelection.toggle()
                } label: {
                    HStack {
                        Image(systemName: "arrow.right")
                        Text("Speichern")
                            .customFont(.headline)
                    }
                    .largeButton(disabled: !canSubmit)
                }
                .disabled(!canSubmit)

            }
            .padding(20)
//            .background(.ultraThinMaterial)
//            .mask(RoundedRectangle(cornerRadius: 20, style: .continuous))
//            .shadow(color: Color("Shadow").opacity(0.3), radius: 5, x: 0, y: 3)
//            .shadow(color: Color("Shadow").opacity(0.3), radius: 30, x: 0, y: 30)
//            .overlay(
//                RoundedRectangle(cornerRadius: 20, style: .continuous)
//                    .stroke(.linearGradient(colors: [.white.opacity(0.8), .white.opacity(0.1)], startPoint: .topLeading, endPoint: .bottomTrailing))
//            )
        }
    }
}

#Preview {
    RefuelView(showAddInfoSelection: .constant(false), showSheet: .constant(false), selection: .constant(-1))
}
