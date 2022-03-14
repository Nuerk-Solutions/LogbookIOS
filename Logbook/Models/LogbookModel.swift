//
//  Logbook.swift
//  Logbook
//
//  Created by Thomas on 16.12.21.
//

import Foundation

struct LogbookModel: Codable, Identifiable {
    var id: String {_id}
    
    var _id: String
    var distanceSinceLastAdditionalInformation: String
    var additionalInformationCost: String
    var additionalInformation: String
    var additionalInformationTyp: AdditionalInformationTypEnum
    var driveReason: String
    var date: Date
    var distanceCost: String
    var distance: String
    var newMileAge: String
    var currentMileAge: String
    var vehicleTyp: VehicleEnum
    var driver: DriverEnum
    
    init() {
        self._id = ""
        self.distanceSinceLastAdditionalInformation = ""
        self.additionalInformationCost = ""
        self.additionalInformation = ""
        self.additionalInformationTyp = .Keine
        self.driveReason = "Stadtfahrt"
        self.date = Date.now
        self.distanceCost = ""
        self.distance = ""
        self.newMileAge = ""
        self.currentMileAge = "0"
        self.vehicleTyp = .Ferrari
        self.driver = .Andrea
    }
    
}

enum DriverEnum: String, CaseIterable, Identifiable, Codable {
    case Andrea
    case Claudia
    case Oliver
    case Thomas
    
    var id: String { self.rawValue }
}
enum VehicleEnum: String, CaseIterable, Identifiable, Codable {
    case Ferrari
    case VW
    case Porsche
    
    var id: String { self.rawValue }
}

enum AdditionalInformationTypEnum: String, Equatable, CaseIterable, Identifiable, Codable {
    case Keine
    case Getankt
    case Gewartet
    
    var id: String { self.rawValue }
}

