//
//  MainView.swift
//  Logbook
//
//  Created by Thomas on 12.12.21.
//

import SwiftUI

struct MainView: View {
    @Binding var currentLogbook: Logbook
    @Binding var lastLogbooks: [Logbook]
    //    @State private var driver: DriverEnum = .Andrea
    //    @State private var vehicle: VehicleEnum = .Ferrari
    //    @State private var date = Date()
    //    @State private var reason = "Stadtfahrt"
    //    @State private var currentMileAge = "0"
    @State private var newMileAge: String = ""
    //    @State private var additionalInformation: AdditionalInformationEnum = .none
    //    @State private var fuelAmount = 0
    //    @State private var serviceDescription = ""
    @State private var showingAlert = false
    @State private var alertTitle = "Alert Title"
    @State private var alertMessage = "Alert Message"
    @ObservedObject private var addLoogbookEntryVM = AddLogbookEntryViewModel()
    @Environment(\.scenePhase) var scenePhase
    
    
    @State private var isLoading = true
    
    
    var body: some View {
        NavigationView {
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
                    .onChange(of: currentLogbook.vehicle.typ) { _ in
                        UIApplication.shared.endEditing()
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    HStack {
                        
                        FloatingNumberField(title: "Aktueller Kilometerstand", text: $currentLogbook.vehicle.currentMileAge)
                            .keyboardType(.decimalPad)
                            .onChange(of: currentLogbook.vehicle.typ) { _ in
                                let currentMilAge = currentLogbook.vehicle.typ == VehicleEnum.VW ? lastLogbooks[0].vehicle.currentMileAge : lastLogbooks[1].vehicle.currentMileAge
                                currentLogbook.vehicle = Vehicle(typ: currentLogbook.vehicle.typ, currentMileAge: currentMilAge, newMileAge: currentMilAge + 1)
                            }
                        
                        Text("km")
                            .padding(.top, 5)
                    }
                    
                    HStack {
                        FloatingTextField(title: "Neuer Kilometerstand", text: $newMileAge)
                            .keyboardType(.decimalPad)
                        
                        Text("km")
                            .padding(.top, 5)
                    }
                    
                })
                
                //                        Section(header: Text("Zusätzliche Information")) {
                //
                //                            Menu {
                //                                ForEach(AdditionalInformationEnum.allCases, id: \.self){ item in
                //                                    Button(item.rawValue) {
                //                                        currentLogbook.additionalInformation?.informationTyp = item
                //                                    }
                //                                }
                //                            } label: {
                //                                VStack(spacing: 5){
                //                                    HStack{
                //                                        Text(LocalizedStringKey(additionalInformation.rawValue) == AdditionalInformationEnum.none.localizedName ? AdditionalInformationEnum.none.localizedName : additionalInformation.localizedName).tag(additionalInformation)
                //                                            .foregroundColor(additionalInformation == AdditionalInformationEnum.none ? .gray : .black)
                //                                        Spacer()
                //                                        Image(systemName: "chevron.down")
                //                                            .foregroundColor(Color.blue)
                //                                            .font(Font.system(size: 20, weight: .bold))
                //                                    }
                //                                    if(currentLogbook.additionalInformation?.informationTyp == AdditionalInformationEnum.none) {
                //                                        Rectangle()
                //                                            .fill(Color.blue)
                //                                            .frame(height: 2)
                //                                            .padding(.top, 1)
                //                                    }
                //
                //                                }
                //                            }
                //                        }
                Section(header: Text("Aktion")) {
                    Button(action: {
                        addLoogbookEntryVM.saveEntry(logbookEntry: currentLogbook)
                        currentLogbook.vehicle.newMileAge = Int(newMileAge) ?? 0
                        if(addLoogbookEntryVM.brokenValues.count > 0) {
                            alertTitle = "Fehler!"
                            alertMessage = addLoogbookEntryVM.brokenValues[0].message
                        }
                        showingAlert = true
                    }) {
                        HStack {
                            Spacer()
                            Text("Speichern")
                            Spacer()
                        }
                    }
                    .foregroundColor(.white)
                    .padding(15)
                    .background(Color.green)
                    .cornerRadius(8)
                    .alert(isPresented: $showingAlert) {
                        if(addLoogbookEntryVM.brokenValues.count > 0) {
                            return Alert(title: Text("\(alertTitle)"),
                                         message: Text("\(alertMessage)"))
                        } else {
                            return Alert(title: Text("Neue Fahrt hinzugefügt"),
                                         message: Text("\(currentLogbook.vehicle.newMileAge)"),
                                         dismissButton: .default(Text("OK")))
                        }
                    }
                    
                    // Delete Last Entry
                    Button(action: {
                        showingAlert = true
                    }) {
                        HStack {
                            Spacer()
                            Text("Letzten Eintrag Löschen")
                            Spacer()
                        }
                    }
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.red)
                    .cornerRadius(8)
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Letzten Eintrag Löschen"),
                              message: Text("Die letzte Fahrt für P-1 gelöscht"),
                              dismissButton: .default(Text("OK")))
                    }
                }
                // Download XLSX
                Button(action: {
                    showingAlert = true
                }) {
                    HStack {
                        Spacer()
                        Text("Download XLSX")
                        Spacer()
                    }
                }
                .foregroundColor(.white)
                .padding(10)
                .cornerRadius(8)
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Öffne Safari..."))
                }
                .listRowBackground(Color.pink)
            }
            .navigationTitle(Text("Fahrtenbuch"))
        }
        .navigationViewStyle(.stack)
        .transition(AnyTransition.opacity.animation(.linear(duration: 1)))
        
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Verbindungsfehler!"), message: Text("Es konnte keine Verbindung zum Server hergestellt werden"), dismissButton: .none)
        }
    }
}
    //
    //struct MainView_Previews: PreviewProvider {
    //    static var previews: some View {
    //        MainView()
    //    }
    //}
