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
    
    
    
    @State var currentLogbook: LogbookModel = LogbookModel()
    @State var latestSelectedLogbook: LogbookModel = LogbookModel()
    @State private var distance: Int = 0
    @State private var descriptionFoucsBool: Bool = false
    @State private var forFree: Bool = false
    @FocusState private var descriptionFocus: Bool
    @FocusState var isInputActive: Bool
    var isReadOnly: Bool = false
    
    @Binding var showSheet: Bool
    
    @StateObject var alertManager = AlertManager()
    @ObservedObject private var addLoogbookEntryVM = AddLogbookEntryViewModel()
    @StateObject private var addViewModel = AddViewModel()
    @EnvironmentObject private var listViewModel: ListViewModel
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.scenePhase) var scenePhase
    @FetchRequest(entity: LogbookSettings.entity(), sortDescriptors: []) var logbookSettings: FetchedResults<LogbookSettings>
    
    @Preference(\.hideKeyboardOnDrag) var hideKeyboardOnDrag
    
    
    
    var body: some View {
        Form {
            Section(header: Text("Fahrerinformationen")) {
                // Driver Segment Picker
                Picker("Fahrer", selection: $currentLogbook.driver.animation()) {
                    ForEach(DriverEnum.allCases) { driver in
                        Text(driver.rawValue.capitalized).tag(driver)
                    }
                }
                .onChange(of: currentLogbook.driver, perform: { newValue in
                    if isReadOnly {
                        return
                    }
                    if(logbookSettings.isEmpty) {
                        let newLogbookSettings = LogbookSettings(context: managedObjectContext)
                        newLogbookSettings.lastDriver = newValue.id
                    } else {
                        logbookSettings[0].lastDriver = newValue.id
                    }
                    try? managedObjectContext.save()
                })
                .pickerStyle(SegmentedPickerStyle())
                
                
                // Date picker
                if isReadOnly {
                    DatePicker("Datum",
                               selection: $currentLogbook.date,
                               displayedComponents: [.date, .hourAndMinute])
                    .environment(\.locale, Locale.init(identifier: "de_DE"))
                    .disabled(isReadOnly)
                } else {
                    DatePicker("Datum",
                               selection: $currentLogbook.date,
                               in: latestSelectedLogbook.date...Date(),
                               displayedComponents: [.date, .hourAndMinute])
                    .environment(\.locale, Locale.init(identifier: "de_DE"))
                    .disabled(isReadOnly)
                }
                
                
                // Reason
                FloatingTextField(title: "Reiseziel", text: $currentLogbook.driveReason)
                    .focused($isInputActive)
                
                
                // ForFree
                if (currentLogbook.driver == .Andrea || currentLogbook.driver == .Thomas) {
                    Toggle(isOn: $forFree) {
                        Text("Kostenlose Fahrt")
                    }
                }
            }
            
            // Vehicle Information
            Section(header: Text("Fahrzeuginformationen"), content: {
                // Vehicle Segment Picker
                Picker("Fahrzeug", selection: $currentLogbook.vehicleTyp) {
                    ForEach(VehicleEnum.allCases) { vehicle in
                        Text(vehicle.id).tag(vehicle)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .disabled(isReadOnly)
                .onChange(of: currentLogbook.vehicleTyp) { newVehicle in
                    // Change currentMilAge on Update of Vehicle switch
                    switch (newVehicle) {
                    case .Ferrari:
                        currentLogbook.currentMileAge = addViewModel.latestLogbooks![1].newMileAge
                        latestSelectedLogbook = addViewModel.latestLogbooks![1]
                        break
                    case .VW:
                        currentLogbook.currentMileAge = addViewModel.latestLogbooks![0].newMileAge
                        latestSelectedLogbook = addViewModel.latestLogbooks![0]
                        break
                    case .Porsche:
                        currentLogbook.currentMileAge = addViewModel.latestLogbooks![2].newMileAge
                        latestSelectedLogbook = addViewModel.latestLogbooks![2]
                        break
                    }
                }
                
                
                HStack {
                    FloatingTextField(title: "Aktueller Kilometerstand", text: $currentLogbook.currentMileAge)
                        .focused($isInputActive)
                        .keyboardType(.decimalPad)
                        .onChange(of: currentLogbook.currentMileAge) { _ in
                            withAnimation {
                                calculateDistance()
                            }
                        }
                        .disabled(isReadOnly)
                    
                    Text("km")
                        .padding(.top, 5)
                        .foregroundColor(.gray)
                }
                
                HStack {
                    FloatingTextField(title: "Neuer Kilometerstand", text: $currentLogbook.newMileAge)
                        .keyboardType(.decimalPad)
                        .focused($isInputActive)
                        .onChange(of: currentLogbook.newMileAge) { _ in
                            withAnimation {
                                calculateDistance()
                            }
                        }
                    
                    Text("km")
                        .padding(.top, 5)
                        .foregroundColor(.gray)
                }
                
                let cost = forFree ? 0 : Double(distance) * 0.2
                if(distance > 0) {
                    HStack {
                        Text("Strecke: \(String(distance)) km\nKosten: \(cost, specifier: "%.2f")€")
                    }
                }
            })
            
            Section(header: Text("Zusätzliche Information")) {
                Menu {
                    ForEach(AdditionalInformationTypEnum.allCases, id: \.self){ item in
                        Button(item.id) {
                            withAnimation {
                                currentLogbook.additionalInformationTyp = item
                            }
                        }
                    }
                } label: {
                    VStack(spacing: 5){
                        HStack{
                            Text(currentLogbook.additionalInformationTyp.id).tag(currentLogbook.additionalInformationTyp)
                                .foregroundColor(currentLogbook.additionalInformationTyp == AdditionalInformationTypEnum.Keine ? .gray : .primary)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(isReadOnly ? .gray : .blue)
                                .font(Font.system(size: 20, weight: .bold))
                        }
                        //                        .transition(.opacity.animation(.linear(duration: 2)))
                        if(currentLogbook.additionalInformationTyp == AdditionalInformationTypEnum.Keine) {
                            Rectangle()
                                .fill(isReadOnly ? .gray : .blue)
                                .frame(height: 2)
                                .padding(.top, 1)
                        }
                    }
                }
                if(currentLogbook.additionalInformationTyp != AdditionalInformationTypEnum.Keine) {
                    if(currentLogbook.additionalInformationTyp == .Getankt) {
                        HStack {
                            FloatingTextField(title: "Menge", text: $currentLogbook.additionalInformation)
                                .focused($isInputActive)
                                .keyboardType(.decimalPad)
                                .submitLabel(.done)
                            
                            Text("L")
                                .padding(.top, 5)
                                .foregroundColor(.gray)
                        }
                        HStack {
                            FloatingTextField(title: "Preis", text: $currentLogbook.additionalInformationCost)
                                .focused($isInputActive)
                                .keyboardType(.decimalPad)
                                .submitLabel(.done)
                            
                            Text("€")
                                .padding(.top, 5)
                                .foregroundColor(.gray)
                        }
                    } else if(currentLogbook.additionalInformationTyp == .Gewartet) {
                        HStack {
                            FloatingTextEditor(title: "Beschreibung", text: $currentLogbook.additionalInformation)
                                .focused($isInputActive)
                        }
                        HStack {
                            FloatingTextField(title: "Preis", text: $currentLogbook.additionalInformationCost)
                                .focused($isInputActive)
                                .keyboardType(.decimalPad)
                            
                            Text("€")
                                .padding(.top, 5)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .disabled(isReadOnly)
            
            Button(action: {
                print("ACTION")
                if !isReadOnly {
                    saveNewLogbook()
                } else {
                    updateLogbook()
                }
            }) {
                HStack {
                    Spacer()
                    Text(isReadOnly ? "Aktualisieren" : "Speichern")
                    Spacer()
                }
            }
            .foregroundColor(.white)
            .padding(10)
            .cornerRadius(8)
            .listRowBackground(isReadOnly ? Color.orange : Color.green)
        }
        .overlay(
            Group {
                if (addViewModel.isLoading && !isReadOnly) {
                    CustomProgressView(message: "Warten...")
                }
            }
        )
        .gesture(DragGesture().onChanged{_ in
            if !descriptionFoucsBool && hideKeyboardOnDrag {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        })
        .uses(alertManager)
        //        .transition(.opacity.animation(.linear(duration: 0.2)))
        .onAppear {
            calculateDistance()
            if(!isReadOnly) {
                Task {
                    await addViewModel.fetchLatestLogbooks()
                }
                UIApplication.shared.applicationIconBadgeNumber = 0
            } else {
                forFree = currentLogbook.forFree ?? false
            }
        }
        
        .onReceive(addViewModel.$latestLogbooks, perform: { newValue in
            if isReadOnly {
                return
            }
            guard let logbooks = newValue
            else {
                return
            }
            self.currentLogbook.currentMileAge = logbooks[1].newMileAge
            self.latestSelectedLogbook = logbooks[1]
            if(!logbookSettings.isEmpty) {
                print(logbookSettings.count)
                self.currentLogbook.driver = DriverEnum(rawValue: logbookSettings[0].lastDriver ?? "Andrea") ?? .Andrea
            }
        })
        .onChange(of: addViewModel.submitted) { newValue in
            if newValue {
                SPAlertView(title: isReadOnly ? "Fahrt aktualisiert" : "Neue Fahrt hinzugefügt", message: "", preset: .done).present(haptic: .success) {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    
                    withAnimation {
                        showSheet = false
                    }
                    
                    listViewModel.refresh(afterNewEntry: true)
                }
            }
        }
        .onChange(of: addViewModel.errorMessage) { newErrorMessage in
            if(newErrorMessage != nil) {
                showSheet = false
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                if !isReadOnly {
                    currentLogbook.date = Date.now
                }
            }
        }
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    if !isReadOnly {
                        saveNewLogbook()
                    } else {
                        updateLogbook()
                    }
                } label: {
                    Text(isReadOnly ? "Aktualisieren" : "Speichern")
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                if !isReadOnly {
                    Button {
                        showSheet.toggle()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30, alignment: .center)
                    }
                }
            }
            
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Fertig") {
                    isInputActive = false
                }
            }
            
        }
    }
    func updateLogbook() {
        print("UPDATE")
        if forFree {
            currentLogbook.forFree = currentLogbook.driver != .Oliver && currentLogbook.driver != .Claudia
        }
        
        addLoogbookEntryVM.saveEntry(logbookEntry: currentLogbook)
        
        if(addLoogbookEntryVM.brokenValues.count != 0) {
            let alert = SPAlertView(title: "", message: addLoogbookEntryVM.brokenValues[0].message, preset: .error)
            alert.dismissByTap = true
            alert.duration = 2.5
            alert.present()
            return
        }
        
        alertManager.show(primarySecondary: .info(title: "Aktualisierung Bestätigen", message: "Fahrer: \(currentLogbook.driver) \n Reiseziel: \(currentLogbook.driveReason)\n Strecke: \(distance)km", primaryButton: Alert.Button.destructive(Text("Bestätigen")) {
//            Task {
                 addViewModel.updateLogbook(logbook: currentLogbook)
//            }
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            
            // Todo Hide Sheet
            if(addViewModel.showAlert) {
                alertManager.show(dismiss: .warning(title: "Fehler", message: addViewModel.errorMessage!, dismissButton: .default(Text("OK"))))
                return
            }
            
        }, secondaryButton: Alert.Button.cancel(Text("Abbrechen"))))
    }
    
    
    func saveNewLogbook() {
        
        if forFree {
            currentLogbook.forFree = currentLogbook.driver != .Oliver && currentLogbook.driver != .Claudia
        }
        
        addLoogbookEntryVM.saveEntry(logbookEntry: currentLogbook)
        
        if(addLoogbookEntryVM.brokenValues.count > 0) {
            let alert = SPAlertView(title: "", message: addLoogbookEntryVM.brokenValues[0].message, preset: .error)
            alert.dismissByTap = true
            alert.duration = 2.5
            alert.present()
            return
        }
        
        alertManager.show(primarySecondary: .info(title: "Eintrag Bestätigen", message: "Fahrer: \(currentLogbook.driver) \n Reiseziel: \(currentLogbook.driveReason)\n Fahrzeug: \(currentLogbook.vehicleTyp) \n Strecke: \(distance)km", primaryButton: Alert.Button.destructive(Text("Bestätigen")) {
            
            // For API accept
            
            currentLogbook.additionalInformationCost = currentLogbook.additionalInformationCost.replacingOccurrences(of: ",", with: ".")
            
            if(currentLogbook.additionalInformationTyp == .Getankt) {
                currentLogbook.additionalInformation = currentLogbook.additionalInformation.replacingOccurrences(of: ",", with: ".")
            }
            Task {
                await addViewModel.submitLogbook(logbook: currentLogbook)
            }
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            
            // Todo Hide Sheet
            if(addViewModel.showAlert) {
                alertManager.show(dismiss: .warning(title: "Fehler", message: addViewModel.errorMessage!, dismissButton: .default(Text("OK"))))
                return
            }
            
        }, secondaryButton: Alert.Button.cancel(Text("Abbrechen"))))
    }
    
    
    func calculateDistance() {
        let currentMilage: Int = Int(currentLogbook.currentMileAge)!
        let newMilage: Int = Int(currentLogbook.newMileAge) ?? 0
        distance = newMilage - currentMilage // When newMileAge is empty or null use currentMilAge
    }
    
}
