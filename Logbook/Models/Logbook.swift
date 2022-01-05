//
//  Logbook.swift
//  Logbook
//
//  Created by Thomas on 16.12.21.
//

import Foundation

struct Logbook: Codable, Identifiable {
    let id = UUID()
    
    var _id: String?
    var driver: DriverEnum
    var vehicle: Vehicle
    var date: Date
    var driveReason: String
    var additionalInformation: AdditionalInformation?
    
    enum CodingKeys: String, CodingKey {
        case driver = "driver"
        case vehicle = "vehicle"
        case date = "date"
        case driveReason = "driveReason"
        case additionalInformation = "additionalInformation"
        case _id = "_id"
    }
}

enum DriverEnum: String, CaseIterable, Identifiable, Codable {
    case Andrea
    case Claudia
    case Oliver
    case Thomas
    
    var id: String { self.rawValue }
}
