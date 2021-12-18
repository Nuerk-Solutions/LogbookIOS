//
//  MainView.swift
//  Logbook
//
//  Created by Thomas on 12.12.21.
//

import SwiftUI

struct LogbookView: View {
    
    @Binding var latestLogbooks: [Logbook]
    //@State private var currentLogbook: Logbook = Logbook(driver: .Andrea, vehicle: Vehicle(typ: .Ferrari, currentMileAge: 0, newMileAge: 0), date: Date(), driveReason: "Stadtfahrt", additionalInformation: nil)
    @Binding var currentLogbook: Logbook
    //    @State private var driver: DriverEnum = .Andrea
    //    @State private var vehicle: VehicleEnum = .Ferrari
    //    @State private var date = Date()
    //    @State private var reason = "Stadtfahrt"
    //    @State private var currentMileAge = "0"
    @State private var newMileAge: String = ""
    @State private var additionalInformationTyp: AdditionalInformationEnum = .none
    @State private var additionalInformationInformation: String = ""
    @State private var additionalInformationCost: String = ""
    //    @State private var fuelAmount = 0
    //    @State private var serviceDescription = ""
    @ObservedObject private var addLoogbookEntryVM = AddLogbookEntryViewModel()
    @EnvironmentObject var viewModel: LogbookViewModel
    @Environment(\.scenePhase) var scenePhase
    
    
    @State private var showingAlert = false
    @State private var alertTitle = "Alert Title"
    @State private var alertMessage = ""
    
    
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
                    .pickerStyle(SegmentedPickerStyle())
                    
                    HStack {
                        
                        FloatingNumberField(title: "Aktueller Kilometerstand", text: $currentLogbook.vehicle.currentMileAge)
                            .keyboardType(.decimalPad)
                            .onChange(of: currentLogbook.vehicle.typ) { _ in
                                let currentMilAge = currentLogbook.vehicle.typ == .VW ? latestLogbooks[0].vehicle.newMileAge : latestLogbooks[1].vehicle.newMileAge
                                currentLogbook.vehicle = Vehicle(typ: currentLogbook.vehicle.typ, currentMileAge: currentMilAge, newMileAge: currentMilAge)
                            }
                        
                        Text("km")
                            .padding(.top, 5)
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        FloatingTextField(title: "Neuer Kilometerstand", text: $newMileAge)
                            .keyboardType(.decimalPad)
                        
                        Text("km")
                            .padding(.top, 5)
                            .foregroundColor(.gray)
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
                                Text(currentLogbook.additionalInformation!.informationTyp.localizedName).tag(currentLogbook.additionalInformation?.informationTyp)
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
                Section(header: Text("Aktion")) {
                    Button(action: {
                        currentLogbook.vehicle.newMileAge = Int(newMileAge) ?? 0
                        addLoogbookEntryVM.saveEntry(logbookEntry: currentLogbook)
                        if(addLoogbookEntryVM.brokenValues.count > 0) {
                            alertTitle = "Fehler!"
                            alertMessage = addLoogbookEntryVM.brokenValues[0].message
                        } else {
                            alertTitle = "Neue Fahrt hinzugefügt"
                        }
                        showingAlert = true
                        print(currentLogbook)
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
                    
                    // Delete Last Entry
                    Button(action: {
                        alertTitle = "Letzten Eintrag Löschen"
                        alertMessage = "Die letzte Fahrt für P-1 gelöscht"
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
                }
                // Download XLSX
                Button(action: {
                    alertTitle = "Öffne Safari..."
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
                .listRowBackground(Color.pink)
            }
            .navigationTitle(Text("Fahrtenbuch"))
            .alert(alertTitle, isPresented: $showingAlert, actions: {
                Button("OK") {}
            }, message: {
                if let alertMessage = alertMessage {
                    Text(alertMessage)
                }
            })
            .gesture(DragGesture().onChanged{_ in UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)})
        }
        .transition(AnyTransition.opacity.animation(.linear(duration: 1)))
    }
}

//#if DEBUG
//struct LogbookView_Previews: PreviewProvider {
//    static var previews: some View {
//        LogbookView(latestLogbooks: .constant([]), currentLogbook: .constant(Logbook(driver: .Andrea, vehicle: Vehicle(typ: .Ferrari, currentMileAge: 0, newMileAge: 0), date: Date(), driveReason: "Stadtfahrt", additionalInformation: nil)))
//    }
//}
//#endif
