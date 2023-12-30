//
//  AddAdditionalInfoView.swift
//  Logbook
//
//  Created by Thomas on 27.05.22.
//
import SwiftUI
import Combine

struct AddAdditionalInfoView: View {
    @Binding var newLogbook: LogbookEntry
    @State private var showFuelField = true
    @State private var changeTitle = true
    @State private var savedMessage = ""
    @State var keyboardRect: CGRect = CGRect()
    @State private var _informationTyp: AdditionalInformationTypEnum = .Getankt
    
    @Binding var show: Bool
    @Namespace var animation
    
    var canSubmit: Bool {
        //        newLogbook.additionalInformation != "" && newLogbook.additionalInformationCost != ""
            false
    }
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Zusätzliche Infoformation")
                .customFont(.largeTitle)
                .multilineTextAlignment(.center)
            //            Text("Es kann pro Eintrag nur eine Zusätzliche Information geben.")
            //                .foregroundColor(.secondary)
            
            
            Picker("", selection: $_informationTyp.animation(.spring())) {
                ForEach([AdditionalInformationTypEnum.Getankt, AdditionalInformationTypEnum.Gewartet]) { informationTyp in
                    Text(informationTyp.rawValue)
                        .tag(informationTyp)
                }
            }
            .onChange(of: _informationTyp, perform: { newValue in
                if newValue == .Getankt && showFuelField {
                    return
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    
                    withAnimation(.spring()) {
                        showFuelField.toggle()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.spring()) {
                            changeTitle.toggle()
                        }
                        
                        withAnimation(.spring()) {
                        let messageToSet = savedMessage
                            savedMessage = newLogbook.additionalInformation
                            newLogbook.additionalInformation = messageToSet
                        }
                    }
                }
            })
            .pickerStyle(.segmented)
            .customFont(.body)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            
            if !showFuelField {
                VStack(alignment: .leading) {
                    Text(changeTitle ? "Menge": "Beschreibung")
                        .customFont(.subheadline)
                        .foregroundColor(.secondary)
                        .matchedGeometryEffect(id: "informationTitle", in: animation)
                    
                        TextEditor(text: $newLogbook.additionalInformation)
                            .addDoneButtonOnKeyboard()
                            .multilineTextAlignment(.leading)
                            .frame(minHeight: 30, maxHeight: 120, alignment: .leading)
                            .textEditorBackground {
                                Color.clear
                            }
                            .scrollContentBackground(.hidden)
                            .background(.clear)
                            .customTextArea()
                            .matchedGeometryEffect(id: "information", in: animation)
                    
                }
            } else {
                VStack(alignment: .leading) {
                    Text(changeTitle ? "Menge": "Beschreibung")
                        .customFont(.subheadline)
                        .foregroundColor(.secondary)
                        .matchedGeometryEffect(id: "informationTitle", in: animation)
                    TextField("", text: $newLogbook.additionalInformation)
                        .addDoneButtonOnKeyboard()
                        .submitLabel(.done)
                        .customTextField(image: Image(systemName: "flame"), suffix: "L")
                        .matchedGeometryEffect(id: "information", in: animation)
                }
            }
            VStack(alignment: .leading) {
                Text("Preis")
                    .customFont(.subheadline)
                    .foregroundColor(.secondary)
                TextField("", text: $newLogbook.additionalInformationCost)
                    .addDoneButtonOnKeyboard()
                    .submitLabel(.done)
                    .customTextField(image: Image(systemName: "creditcard.fill")
                                     ,suffix: "€")
            }
            Button {
                if canSubmit {
                    withAnimation(.spring()) {
                        isLoading = false
                        show = false
                    }
                }
            } label: {
                HStack {
                    Image(systemName: "arrow.right")
                    Text("Hinzufügen")
                        .customFont(.headline)
                }
                .largeButton(disabled: !canSubmit)
            }
            .disabled(!canSubmit)
        }
        .padding(30)
        .background(.regularMaterial)
        .mask(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color("Shadow").opacity(0.3), radius: 5, x: 0, y: 3)
        .shadow(color: Color("Shadow").opacity(0.3), radius: 30, x: 0, y: 30)
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(.linearGradient(colors: [.white.opacity(0.8), .white.opacity(0.1)], startPoint: .topLeading, endPoint: .bottomTrailing))
        )
        .blur(radius: isLoading ? 1.5 : 0)
        .padding()
    }
}

struct AddAdditionalInfoView_Previews: PreviewProvider {
    static var previews: some View {
        AddAdditionalInfoView(newLogbook: .constant(LogbookEntry()), show: .constant(true))
    }
}
