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
    var distance: Int?
    //    var cost: Float
    
    enum CodingKeys: String, CodingKey {
        case typ = "typ"
        case currentMileAge = "currentMileAge"
        case newMileAge = "newMileAge"
        case distance = "distance"
    }
}

enum VehicleEnum: String, CaseIterable, Identifiable, Codable {
    case Ferrari
    case VW
    
    var id: String { self.rawValue }
}
