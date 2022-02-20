//
//  PatrolStationModel.swift
//  Logbook
//
//  Created by Thomas on 19.02.22.
//

import Foundation

struct PatrolStationModel: Codable, Identifiable {
    
    let id = UUID()
    var ok: Bool
    var status: String
    var stations: [StationModel]
    
}

struct StationModel: Codable, Identifiable {
    var id: String
    var name: String
    var brand: String
    var street: String
    var place: String
    var lat: Double
    var lng: Double
    var dist: Double
    var price: Double
    var isOpen: Bool
    var houseNumber: String
    var postCode: Int
}
