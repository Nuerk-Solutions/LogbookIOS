//
//  InvoiceModel.swift
//  Logbook
//
//  Created by Thomas on 22.04.22.
//

import Foundation

struct InvoiceModel: Codable {
    var driver: String
    var distance: Int
    var distanceCost: Double
    var vehicles: Vehicles
    var drivesCostForFree: Double?
}

// MARK: FIX THIS
// TODO: FIX THIS

struct Vehicles: Codable {
    let ferrari: InvoiceVehicle?
    let vw: InvoiceVehicle?
    let porsche: InvoiceVehicle?
    
    enum CodingKeys: String, CodingKey {
        case ferrari = "Ferrari"
        case vw = "VW"
        case porsche = "Porsche"
    }
}


struct InvoiceVehicle: Codable, Hashable {
    var distance: Int
    var distanceCost: Double
    var drivesCostForFree: Double?
}
