//
//  AddLogbook.swift
//  Logbook
//
//  Created by Thomas on 06.01.22.
//

import SwiftUI
import AlertKit
import SPAlert

struct AddLogbookView: View {
    
    @State var currentLogbook: Logbook
    @State private var newMileAge: String = ""
    @State private var additionalInformationInformation: String = ""
    @State private var additionalInformationCost: String = ""
    
    
    @StateObject var alertManager = AlertManager()
    @ObservedObject private var addLoogbookEntryVM = AddLogbookEntryViewModel()
    
    var body: some View {
            Form {
                Section(header: Text("Fahrerinformationen")) {
                    // Driver Segment Picker
                    Picker("Fahrer", selection: $currentLogbook.driver) {
                        ForEach(DriverEnum.allCases) { driver in
                            Text(driver.rawValue.capitalized).tag(driver)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    
                    // Date picker
                    DatePicker("Datum",
                               selection: $currentLogbook.date,
                               displayedComponents: [.date])
                        .environment(\.locale, Locale.init(identifier: "de"))
                    
                    // Reason
                    FloatingTextField(title: "Reiseziel", text: $currentLogbook.driveReason)
                }
                
                // Vehicle Information
                Section(header: Text("Fahrzeuginformationen"), content: {
                    // Vehicle Segment Picker
                    Picker("Fahrzeug", selection: $currentLogbook.vehicle.typ) {
                        ForEach(VehicleEnum.allCases) { vehicle in
                            Text(vehicle.rawValue).tag(vehicle)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    HStack {
                        
                        FloatingNumberField(title: "Aktueller Kilometerstand", text: $currentLogbook.vehicle.currentMileAge)
                            .keyboardType(.decimalPad)
//                            .onChange(of: currentLogbook.vehicle.typ) { _ in
//                                let currentMilAge = currentLogbook.vehicle.typ == .VW ? latestLogbooks[0].vehicle.newMileAge : latestLogbooks[1].vehicle.newMileAge
//                                currentLogbook.vehicle = Vehicle(typ: currentLogbook.vehicle.typ, currentMileAge: currentMilAge, newMileAge: currentMilAge)
//                            }
                        
                        Text("km")
                            .padding(.top, 5)
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        FloatingNumberField(title: "Neuer Kilometerstand", text: $currentLogbook.vehicle.newMileAge)
                            .keyboardType(.decimalPad)
                        
                        Text("km")
                            .padding(.top, 5)
                            .foregroundColor(.gray)
                    }
                    let distance: Int  = (Int(newMileAge) ?? currentLogbook.vehicle.currentMileAge) - currentLogbook.vehicle.currentMileAge
                    let cost = Double(distance) * 0.2
                    if(distance > 0) {
                        HStack {
                            Text("Strecke: \(String(distance)) km\nKosten: \(cost, specifier: "%.2f")€")
                        }
                    }
                })
                
                Section(header: Text("Zusätzliche Information")) {
                    Menu {
                        ForEach(AdditionalInformationEnum.allCases, id: \.self){ item in
                            Button(item.rawValue) {
                                currentLogbook.additionalInformation?.informationTyp = item
                            }
                        }
                    } label: {
                        VStack(spacing: 5){
                            HStack{
                                Text(currentLogbook.additionalInformation?.informationTyp!.localizedName ?? AdditionalInformationEnum.none.localizedName).tag(currentLogbook.additionalInformation?.informationTyp)
                                    .foregroundColor(currentLogbook.additionalInformation?.informationTyp == AdditionalInformationEnum.none ? .gray : .primary)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(Color.blue)
                                    .font(Font.system(size: 20, weight: .bold))
                            }
                            .transition(.opacity.animation(.linear(duration: 2)))
                            if(currentLogbook.additionalInformation?.informationTyp == AdditionalInformationEnum.none) {
                                Rectangle()
                                    .fill(Color.blue)
                                    .frame(height: 2)
                                    .padding(.top, 1)
                            }
                        }
                    }
                    if(currentLogbook.additionalInformation?.informationTyp != AdditionalInformationEnum.none) {
                        if(currentLogbook.additionalInformation?.informationTyp == .refuled) {
                            HStack {
                                FloatingTextField(title: "Menge", text: $additionalInformationInformation)
                                    .keyboardType(.decimalPad)
                                
                                Text("L")
                                    .padding(.top, 5)
                                    .foregroundColor(.gray)
                            }
                            HStack {
                                FloatingTextField(title: "Preis", text: $additionalInformationCost)
                                    .keyboardType(.decimalPad)
                                
                                Text("€")
                                    .padding(.top, 5)
                                    .foregroundColor(.gray)
                            }
                        } else if(currentLogbook.additionalInformation?.informationTyp == .service) {
                            HStack {
                                FloatingTextEditor(title: "Beschreibung", text: $additionalInformationInformation)
                            }
                            HStack {
                                FloatingTextField(title: "Preis", text: $additionalInformationCost)
                                    .keyboardType(.decimalPad)
                                
                                Text("€")
                                    .padding(.top, 5)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                
                Button(action: {
                    let finalLogbook = Logbook(driver: currentLogbook.driver,
                                               vehicle: Vehicle(typ: currentLogbook.vehicle.typ, currentMileAge: currentLogbook.vehicle.currentMileAge, newMileAge: Int(newMileAge) ?? 0),
                                               date: currentLogbook.date,
                                               driveReason: currentLogbook.driveReason,
                                               additionalInformation: currentLogbook.additionalInformation?.informationTyp == AdditionalInformationEnum.none ? nil :
                                                AdditionalInformation(informationTyp: currentLogbook.additionalInformation?.informationTyp, information: additionalInformationInformation, cost: additionalInformationCost))
                    
                    addLoogbookEntryVM.saveEntry(logbookEntry: finalLogbook)
                    if(addLoogbookEntryVM.brokenValues.count > 0) {
                        let alert = SPAlertView(title: "", message: addLoogbookEntryVM.brokenValues[0].message, preset: .error)
                        alert.dismissByTap = true
                        alert.duration = 2.5
                        alert.present()
                        return
                    }
                    let distance: Int  = (Int(newMileAge) ?? currentLogbook.vehicle.currentMileAge) - currentLogbook.vehicle.currentMileAge
                    //                        alertManager.show(primarySecondary: .info(title: "Eintrag Bestätigen", message: "Fahrer: \(finalLogbook.driver) \n Reiseziel: \(finalLogbook.driveReason)\n Fahrzeug: \(finalLogbook.vehicle.typ) \n Strecke: \(distance)km", primaryButton: Alert.Button.destructive(Text("Bestätigen")) {
                    //                            viewModel.submitLogbook(httpBody: finalLogbook)
                    //
                    //                            newMileAge = ""
                    //                            additionalInformationCost = ""
                    //                            additionalInformationInformation = ""
                    //                            currentLogbook.additionalInformation?.informationTyp = AdditionalInformationEnum.none
                    //
                    //                            SPAlertView(title: "Neue Fahrt hinzugefügt", message: "", preset: .done).present(haptic: .success) {
                    //                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    //
                    //                                viewModel.fetchLatestLogbooks()
                    //
                    //                            }
                    //                        }, secondaryButton: Alert.Button.cancel(Text("Abbrechen"))))
                }) {
                    HStack {
                        Spacer()
                        Text("Speichern")
                        Spacer()
                    }
                }
                .foregroundColor(.white)
                .padding(10)
                .cornerRadius(8)
                .listRowBackground(Color.green)
            }
            .navigationTitle("Eintrag")
            .navigationBarTitleDisplayMode(.automatic)
            .gesture(DragGesture().onChanged{_ in UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)})
            .uses(alertManager)
            .transition(AnyTransition.opacity.animation(.linear(duration: 0.2)))
    }
}

//struct AddLogbookViews_Previews: PreviewProvider {
//    static var previews: some View {
//        AddLogbookView()
//    }
//}
