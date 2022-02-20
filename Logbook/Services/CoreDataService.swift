//
//  CoreDataService.swift
//  Logbook
//
//  Created by Thomas on 20.02.22.
//

import Foundation
import CoreData

class CoreDataService: ObservableObject {
    
    let container = NSPersistentContainer(name: "CoreDataModel")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Core Data Store failed \(error.localizedDescription)")
            }
        }
    }    
}
