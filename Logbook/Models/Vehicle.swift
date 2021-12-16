//
//  Vehicle.swift
//  Logbook
//
//  Created by Thomas on 16.12.21.
//

import Foundation

struct Vehicle: Codable, Identifiable, Hashable {
    let id = UUID()
    
    var typ: VehicleEnum
    var currentMileAge: Int
    var newMileAge: Int
    //    var distance: Int
    //    var cost: Float
}
