//
//  LogbookApp.swift
//  Logbook
//
//  Created by Thomas on 01.12.21.
//

import SwiftUI

@main
struct LogbookApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            if #available(iOS 15.0, *) {
                ContentView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            } else {
                // Fallback on earlier versions
            }
        }
    }
}
