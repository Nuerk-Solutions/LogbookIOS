//
//  LogbookApp.swift
//  Logbook
//
//  Created by Thomas on 01.12.21.
//

import SwiftUI

@main
struct LogbookApp: App {
    
    @StateObject private var coreDataService = CoreDataService()
    @StateObject private var locationService = LocationService()
    
    @AppStorage("developerconsole") private var developerconsole = false
    @AppStorage("measureSpeed") private var measureSpeed = false
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, coreDataService.container.viewContext)
                .environmentObject(locationService)
                .onAppear {
                    // To Hide Constrains warnings
                    UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
                    // Textfield clearButton active
                    UITextField.appearance().clearButtonMode = .whileEditing
                }
                .onAppear {
                    if developerconsole {
                        consoleManager.isVisible = true
                    }
                    if measureSpeed {
                        GlobalVariable.measure = true
                    }
                }
        }
    }
}
