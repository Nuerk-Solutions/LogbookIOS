//
//  Logbook.swift
//  Logbook
//
//  Created by Thomas on 16.12.21.
//

import Foundation

struct LogbookModel: Codable, Identifiable, Equatable {
    var id: String {_id}
    
    var _id: String
    var distanceSinceLastAdditionalInformation: String
    var additionalInformationCost: String
    var additionalInformation: String
    var additionalInformationTyp: AdditionalInformationTypEnum
    var driveReason: String
    var forFree: Bool? // Nullable beacuse since b26
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
        self.forFree = false
        self.date = Date.now
        self.distanceCost = ""
        self.distance = ""
        self.newMileAge = ""
        self.currentMileAge = "0"
        self.vehicleTyp = .Ferrari
        self.driver = .Andrea
    }
    
    init(with model: LogbookModel) {
        self._id = model._id
        self.distanceSinceLastAdditionalInformation = model.distanceSinceLastAdditionalInformation
        self.additionalInformationCost = model.additionalInformationCost
        self.additionalInformation = model.additionalInformation
        self.additionalInformationTyp = model.additionalInformationTyp
        self.driveReason = model.driveReason
        self.forFree = model.forFree
        self.date = model.date
        self.distanceCost = model.distanceCost
        self.distance = model.distance
        self.newMileAge = model.newMileAge
        self.currentMileAge = model.currentMileAge
        self.vehicleTyp = model.vehicleTyp
        self.driver = model.driver
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

