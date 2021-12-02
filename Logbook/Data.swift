//
//  Data.swift
//  Logbook
//
//  Created by Thomas on 02.12.21.
//

import SwiftUI

struct Logbook: Codable, Identifiable {
    let id = UUID()
    var driver: String
    var vehicle: Vehicle
    var date: String
    var driveReason: String
}

struct Vehicle: Codable, Identifiable {
    let id = UUID()
    
    var typ: String
    var currentMileAge: Int
    var newMileAge: Int
    var distance: Int
    var cost: Float
}

class Api {
    func getLogbookEntries(completion: @escaping ([Logbook]) -> ()) {
        guard let url = URL(string: "https://api.nuerk-solutions.de/logbook") else { return } // guard adds a condition. because swift is typesafe you need to be sure to have the right type; if the URL is empty or nil then return the func at that point
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            let logbookEntries = try! JSONDecoder().decode([Logbook].self, from: data!) // json decode
            DispatchQueue.main.async {
                completion(logbookEntries)
            }
        }
        .resume()
    }
}
