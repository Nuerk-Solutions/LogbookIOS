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
    @State private var currentMileAge = 0
    @State private var newMileAge = 0
    @State private var additionalInformation: AdditionalInformation = .Nichts
    @State private var fuelAmount = 0
    @State private var serviceDescription = ""
    
    enum Driver: String, CaseIterable, Identifiable {
        case Andrea
        case Claudia
        case Oliver
        case Thomas
        
        var id: String { self.rawValue }
    }
    
    enum Vehicle: String, CaseIterable, Identifiable {
        case Ferrari
        case VW
        
        var id: String { self.rawValue }
    }
    
    enum AdditionalInformation: String, CaseIterable, Identifiable {
        case Nichts
        case Getankt
        case Gewartet
        
        var id: String { self.rawValue }
    }
    
    @State var username: String = ""
    @State var isPrivate: Bool = true
    @State var notificationsEnabled: Bool = false
    @State private var previewIndex = 0
    @State var stand = "123"
    @State private var showingAlert = false
    @State var value = ""
    var placeholder = "Select Client"
    var dropDownList = ["PSO", "PFA", "AIR", "HOT"]
    var previewOptions = ["Always", "When Unlocked", "Never"]
    
    enum Gender: String, CaseIterable, Identifiable {
        case male
        case female
        case other
        
        var id: String { self.rawValue }
    }
    
    enum Language: String, CaseIterable, Identifiable {
        case english
        case french
        case spanish
        case japanese
        case other
        
        var id: String { self.rawValue }
    }
    
    @State var name: String = ""
    @State var password: String = ""
    
    @State var gender: Gender = .male
    @State var language: Language = .english
    @State private var birthdate = Date()
    
    @State var isPublic: Bool = true
    
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Fahrerinfors")) {
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
                    
                    HStack {
                        Text("Reiseziel")
                        TextField("Stadtfahrt", text: $reason)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
                
                Section(header: Text("Fahrzeuginfos"), content: {
                    // Vehicle Segment Picker
                    Picker("Fahrzeug", selection: $vehicle) {
                        ForEach(Vehicle.allCases) { vehicle in
                            Text(vehicle.rawValue).tag(vehicle)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                })
                
                Section(header: Text("NOTIFICATIONS")) {
                    Toggle(isOn: $notificationsEnabled) {
                        Text("Enabled")
                    }
                    Picker(selection: $previewIndex, label: Text("Show Previews")) {
                        ForEach(0 ..< previewOptions.count) {
                            Text(self.previewOptions[$0])
                        }
                    }
                }
                
                Section(header: Text("ABOUT")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("2.2.1")
                    }
                }
                
                Section(header: Text("Credentials")) {
                    
                    Menu {
                        ForEach(dropDownList, id: \.self){ client in
                            Button(client) {
                                self.value = client
                            }
                        }
                    } label: {
                        VStack(spacing: 5){
                            HStack{
                                Text(value.isEmpty ? placeholder : value)
                                    .foregroundColor(value.isEmpty ? .gray : .black)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(Color.orange)
                                    .font(Font.system(size: 20, weight: .bold))
                            }
                            .padding(.horizontal)
                            Rectangle()
                                .fill(Color.orange)
                                .frame(height: 2)
                        }
                    }
                }
                
                
                
                // Secure field
                TextField("Tankstand", text: $stand)
                    .keyboardType(.numberPad)
                    .onReceive(Just(stand)) { newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        if filtered != newValue {
                            self.stand = filtered
                        }
                    }
                
                Section(header: Text("User Info")) {
                    // Date picker
                    DatePicker("Date of birth",
                               selection: $birthdate,
                               displayedComponents: [.date])
                    // Scroll picker
                    Picker("Language", selection: $language) {
                        ForEach(Language.allCases) { language in
                            Text(language.rawValue.capitalized).tag(language)
                        }
                    }
                }
                Section {
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
                    .padding(10)
                    .background(Color.accentColor)
                    .cornerRadius(8)
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Form submitted"),
                              message: Text("Speichern"),
                              dismissButton: .default(Text("OK")))
                    }
                }
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

