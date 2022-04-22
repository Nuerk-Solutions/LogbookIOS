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
    var vehicles: [InvoiceVehicle]
}


struct InvoiceVehicle: Codable {
    var distance: Int
    var distanceCost: Double
}
