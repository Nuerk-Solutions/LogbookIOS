//
//  ContentView.swift
//  Logbook
//
//  Created by Thomas on 01.12.21.
//

import SwiftUI
import CoreData
import Combine

struct ContentView: View {
    
    @State private var driver: Driver = .Andrea
    @State private var vehicle: Vehicle = .Ferrari
    @State private var date = Date()
    @State private var reason = "Stadtfahrt"
    @ObservedObject private var currentMileAge = NumbersOnly(value: "123")
    @ObservedObject private var newMileAge = NumbersOnly(value: "321")
    @State private var additionalInformation: AdditionalInformation = .none
    @State private var fuelAmount = 0
    @State private var serviceDescription = ""
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Fahrerinformationen")) {
                    // Driver Segment Picker
                    Picker("Fahrer", selection: $driver) {
                        ForEach(Driver.allCases) { driver in
                            Text(driver.rawValue.capitalized).tag(driver)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    // Date picker
                    DatePicker("Datum",
                               selection: $date,
                               displayedComponents: [.date])
                    
                    // Reason
                    FloatingTextField(title: "Reiseziel", text: $reason)
                }
                
                // Vehicle Information
                Section(header: Text("Fahrzeuginformationen"), content: {
                    // Vehicle Segment Picker
                    Picker("Fahrzeug", selection: $vehicle) {
                        ForEach(Vehicle.allCases) { vehicle in
                            Text(vehicle.rawValue).tag(vehicle)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    HStack {
                        FloatingTextField(title: "Aktueller Kilometerstand", text: $currentMileAge.value)
                            .keyboardType(.decimalPad)
                        
                        Text("km")
                            .padding(.top, 5)
                    }
                    
                    HStack {
                        FloatingTextField(title: "Neuer Kilometerstand", text: $newMileAge.value)
                            .keyboardType(.decimalPad)
                        
                        Text("km")
                            .padding(.top, 5)
                    }
                    
                })
                
                Section(header: Text("Zusätzliche Information")) {
                    
                    Menu {
                        ForEach(AdditionalInformation.allCases, id: \.self){ item in
                            Button(item.rawValue) {
                                self.additionalInformation = item
                            }
                        }
                    } label: {
                        VStack(spacing: 5){
                            HStack{
                                Text(LocalizedStringKey(additionalInformation.rawValue) == AdditionalInformation.none.localizedName ? AdditionalInformation.none.localizedName : additionalInformation.localizedName).tag(additionalInformation)
                                    .foregroundColor(additionalInformation == AdditionalInformation.none ? .gray : .black)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(Color.blue)
                                    .font(Font.system(size: 20, weight: .bold))
                            }
                            if(additionalInformation == AdditionalInformation.none) {
                                Rectangle()
                                    .fill(Color.blue)
                                    .frame(height: 2)
                                    .padding(.top, 1)
                            }
                            
                        }
                    }
                }
                Section(header: Text("Aktion")) {
                    Button(action: {
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
                        Alert(title: Text("Neue Fahrt hinzugefügt"),
                              message: Text("Neue Fahrt mit P-1km im Fahrzeug P-2 für den Fahrer P-3"),
                              dismissButton: .default(Text("OK")))
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
            .navigationBarTitle("Fahrtenbuch")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

