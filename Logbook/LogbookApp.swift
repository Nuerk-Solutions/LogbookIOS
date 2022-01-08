//
//  LogbookApp.swift
//  Logbook
//
//  Created by Thomas on 01.12.21.
//

import SwiftUI

@main
struct LogbookApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    // To Hide Constrains warnings
                    UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
                    // Textfield clearButton active
                    UITextField.appearance().clearButtonMode = .whileEditing
                }
        }
    }
}
