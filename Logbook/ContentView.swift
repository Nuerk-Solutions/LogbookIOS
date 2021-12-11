//
//  ContentView.swift
//  Logbook
//
//  Created by Thomas on 01.12.21.
//

import SwiftUI
import CoreData
import Combine
import SDWebImageSwiftUI

struct ContentView: View {
    
    @State private var lastLogbooks: [Logbook] = []
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
    
    @State private var currentLogbook = Logbook(driver: .Andrea, vehicle: Vehicle(typ: .Ferrari, currentMileAge: 0, newMileAge: 0), date: Date(), driveReason: "Stadtfahrt", additionalInformation: nil)
    
    var body: some View {
        
        SplashScreen()
        
//        ZStack {
//            if(isLoading) {
//               CircleLoader()
//                   .transition(AnyTransition.opacity.animation(.linear(duration: 1)))
//            }
//            if !isLoading {
//                NavigationView {
//                    Form {
//                        Section(header: Text("Fahrerinformationen")) {
//                            // Driver Segment Picker
//                            Picker("Fahrer", selection: $currentLogbook.driver) {
//                                ForEach(DriverEnum.allCases) { driver in
//                                    Text(driver.rawValue.capitalized).tag(driver)
//                                }
//                            }
//                            .pickerStyle(SegmentedPickerStyle())
//
//                            // Date picker
//                            DatePicker("Datum",
//                                       selection: $currentLogbook.date,
//                                       displayedComponents: [.date])
//                                .environment(\.locale, Locale.init(identifier: "de"))
//
//                            // Reason
//                            FloatingTextField(title: "Reiseziel", text: $currentLogbook.driveReason)
//                        }
//
//                        // Vehicle Information
//                        Section(header: Text("Fahrzeuginformationen"), content: {
//                            // Vehicle Segment Picker
//                            Picker("Fahrzeug", selection: $currentLogbook.vehicle.typ) {
//                                ForEach(VehicleEnum.allCases) { vehicle in
//                                    Text(vehicle.rawValue).tag(vehicle)
//                                }
//                            }
//                            .onChange(of: currentLogbook.vehicle.typ) { _ in
//                                UIApplication.shared.endEditing()
//                            }
//                            .pickerStyle(SegmentedPickerStyle())
//
//                            HStack {
//
//                                FloatingNumberField(title: "Aktueller Kilometerstand", text: $currentLogbook.vehicle.currentMileAge)
//                                    .keyboardType(.decimalPad)
//                                    .onChange(of: currentLogbook.vehicle.typ) { _ in
//                                        let currentMilAge = currentLogbook.vehicle.typ == VehicleEnum.VW ? lastLogbooks[0].vehicle.currentMileAge : lastLogbooks[1].vehicle.currentMileAge
//                                        currentLogbook.vehicle = Vehicle(typ: currentLogbook.vehicle.typ, currentMileAge: currentMilAge, newMileAge: currentMilAge + 1)
//                                    }
//
//                                Text("km")
//                                    .padding(.top, 5)
//                            }
//
//                            HStack {
//                                FloatingTextField(title: "Neuer Kilometerstand", text: $newMileAge)
//                                    .keyboardType(.decimalPad)
//
//                                Text("km")
//                                    .padding(.top, 5)
//                            }
//
//                        })
//
////                        Section(header: Text("Zusätzliche Information")) {
////
////                            Menu {
////                                ForEach(AdditionalInformationEnum.allCases, id: \.self){ item in
////                                    Button(item.rawValue) {
////                                        currentLogbook.additionalInformation?.informationTyp = item
////                                    }
////                                }
////                            } label: {
////                                VStack(spacing: 5){
////                                    HStack{
////                                        Text(LocalizedStringKey(additionalInformation.rawValue) == AdditionalInformationEnum.none.localizedName ? AdditionalInformationEnum.none.localizedName : additionalInformation.localizedName).tag(additionalInformation)
////                                            .foregroundColor(additionalInformation == AdditionalInformationEnum.none ? .gray : .black)
////                                        Spacer()
////                                        Image(systemName: "chevron.down")
////                                            .foregroundColor(Color.blue)
////                                            .font(Font.system(size: 20, weight: .bold))
////                                    }
////                                    if(currentLogbook.additionalInformation?.informationTyp == AdditionalInformationEnum.none) {
////                                        Rectangle()
////                                            .fill(Color.blue)
////                                            .frame(height: 2)
////                                            .padding(.top, 1)
////                                    }
////
////                                }
////                            }
////                        }
//                        Section(header: Text("Aktion")) {
//                            Button(action: {
//                                addLoogbookEntryVM.saveEntry(logbookEntry: currentLogbook)
//                                currentLogbook.vehicle.newMileAge = Int(newMileAge) ?? 0
//                                if(addLoogbookEntryVM.brokenValues.count > 0) {
//                                    alertTitle = "Fehler!"
//                                    alertMessage = addLoogbookEntryVM.brokenValues[0].message
//                                }
//                                showingAlert = true
//                            }) {
//                                HStack {
//                                    Spacer()
//                                    Text("Speichern")
//                                    Spacer()
//                                }
//                            }
//                            .foregroundColor(.white)
//                            .padding(15)
//                            .background(Color.green)
//                            .cornerRadius(8)
//                            .alert(isPresented: $showingAlert) {
//                                if(addLoogbookEntryVM.brokenValues.count > 0) {
//                                    return Alert(title: Text("\(alertTitle)"),
//                                                 message: Text("\(alertMessage)"))
//                                } else {
//                                    return Alert(title: Text("Neue Fahrt hinzugefügt"),
//                                                 message: Text("\(currentLogbook.vehicle.newMileAge)"),
//                                                 dismissButton: .default(Text("OK")))
//                                }
//                            }
//
//                            // Delete Last Entry
//                            Button(action: {
//                                showingAlert = true
//                            }) {
//                                HStack {
//                                    Spacer()
//                                    Text("Letzten Eintrag Löschen")
//                                    Spacer()
//                                }
//                            }
//                            .foregroundColor(.white)
//                            .padding(10)
//                            .background(Color.red)
//                            .cornerRadius(8)
//                            .alert(isPresented: $showingAlert) {
//                                Alert(title: Text("Letzten Eintrag Löschen"),
//                                      message: Text("Die letzte Fahrt für P-1 gelöscht"),
//                                      dismissButton: .default(Text("OK")))
//                            }
//                        }
//                        // Download XLSX
//                        Button(action: {
//                            showingAlert = true
//                        }) {
//                            HStack {
//                                Spacer()
//                                Text("Download XLSX")
//                                Spacer()
//                            }
//                        }
//                        .foregroundColor(.white)
//                        .padding(10)
//                        .cornerRadius(8)
//                        .alert(isPresented: $showingAlert) {
//                            Alert(title: Text("Öffne Safari..."))
//                        }
//                        .listRowBackground(Color.pink)
//                    }
//                    .navigationTitle(Text("Fahrtenbuch"))
//                }
//                .navigationViewStyle(.stack)
//                .transition(AnyTransition.opacity.animation(.linear(duration: 1)))
//            }
//        }
//        .onChange(of: scenePhase) { newPhase in
//            if(newPhase == .active) {
//                Api().getLogbookEntries{(logbooks, error)  in
//                    if(error == nil) {
//                        self.lastLogbooks = logbooks!
//
//                        let currentMilAge = currentLogbook.vehicle.typ == VehicleEnum.VW ? lastLogbooks[0].vehicle.currentMileAge : lastLogbooks[1].vehicle.currentMileAge
//
//                        if (currentLogbook.vehicle.typ == VehicleEnum.VW) {
//                            currentLogbook.vehicle = Vehicle(typ: .VW, currentMileAge: currentMilAge, newMileAge: currentMilAge + 1)
//                        } else {
//                            currentLogbook.vehicle = Vehicle(typ: .Ferrari, currentMileAge: currentMilAge, newMileAge: currentMilAge + 1)
//                        }
//
//                        isLoading = false
//                        print("Fetch in UI Sucessfully")
//                    } else {
//                        if(error! as! HttpError == HttpError.statusNot200) {
//                            showingAlert = true
//                        }
//                    }
//                }
//            } else {
//                isLoading = true
//            }
//        }
//        .alert(isPresented: $showingAlert) {
//            Alert(title: Text("Verbindungsfehler!"), message: Text("Es konnte keine Verbindung zum Server hergestellt werden"), dismissButton: .none)
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
            ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}


struct SplashScreen: View {
    @State private var animationFinished = false
    var body: some View {
        ZStack {
            Text("Hello")
            Color("BG").ignoresSafeArea()
            
            AnimatedImage(url: getImageURL())
                .aspectRatio(contentMode: .fit)
                
            
        }
        .opacity(animationFinished ? 0 : 1)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    withAnimation(.easeInOut(duration: 0.7)) {
                        animationFinished = true
                    }
                }
            }
    }
    
    func getImageURL() -> URL {
        let bundle = Bundle.main.path(forResource: "Car_load", ofType: "gif")
        let url = URL(fileURLWithPath: bundle ?? "")
        
        return url
    }
}
