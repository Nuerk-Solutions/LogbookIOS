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
    
    @Preference(\.developerconsole) var developerconsole
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, coreDataService.container.viewContext)
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
                }
        }
    }
}
