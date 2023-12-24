//
//  LogbookEntry.swift
//  Logbook
//
//  Created by Thomas on 26.05.22.
//

import Foundation
import SwiftUI_Extensions
import Charts

struct LogbookEntry {
    
    init() {
        self._id = nil
        self.distanceSinceLastAdditionalInformation = ""
        self.additionalInformationCost = ""
        self.additionalInformation = ""
        self.additionalInformationTyp = .Keine
        self.driveReason = "Stadtfahrt"
        self.forFree = false
        self.date = Date()
        self.distanceCost = "0"
        self.distance = "0"
        self.newMileAge = ""
        self.currentMileAge = "100"
        self.vehicleTyp = .Ferrari
        self.driver = .Andrea
        self.animated = false
    }
    
    let id = UUID()
    
    let _id: String?
    var distanceSinceLastAdditionalInformation: String

    var additionalInformationCost: String
    var additionalInformation: String
    var additionalInformationTyp: AdditionalInformationTypEnum

    var driveReason: String
    var forFree: Bool? // Nullable, since b26
    var date: Date
    var distanceCost: String
    var distance: String
    var newMileAge: String
    var currentMileAge: String
    var vehicleTyp: VehicleEnum
    var driver: DriverEnum

    var forFreeBool: Bool {
        forFree ?? false
    }
    
    var animated: Bool? = false
}

extension LogbookEntry: Codable {}
extension LogbookEntry: Equatable {}
extension LogbookEntry: Identifiable {}

extension LogbookEntry {
    
    static var previewData: [LogbookEntry] {
        let previewDataURL = Bundle.main.url(forResource: "logbooks", withExtension: "json")!
        let data = try! Data(contentsOf: previewDataURL)
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(.iso8601Full)
        
        let apiResponse = try! jsonDecoder.decode([LogbookEntry].self, from: data)
        
        return apiResponse
    }
}


enum DriverEnum: String, CaseIterable, Codable, Identifiable {
    case Andrea
    case Claudia
    case Oliver
    case Thomas
    
    var id: String { UUID().uuidString }
}
enum VehicleEnum: String, CaseIterable, Identifiable, Codable, Equatable {
    case Ferrari
    case VW
    case Porsche
    case MX5
    case DS
    
    var fuelTyp: FuelTyp {
        switch self {
        case .Ferrari, .MX5:
            return .SUPER
        case .VW:
            return .DIESEL
        case .Porsche, .DS:
            return .SUPER_E10
        }
    }
    
    var fuelDescription: String {
        switch self {
        case .Ferrari, .MX5:
            return "In den \(self.id) wird nur Super E5 getankt."
        case .VW:
            return "In den VW wird nur Diesel getankt."
        case .Porsche, .DS:
            return "In den \(self.id) wird nur Super+ E5 getankt."
        }
    }
    
    var id: String { UUID().uuidString }
}

enum AdditionalInformationTypEnum: String, Equatable, CaseIterable, Codable, Identifiable {
    case Keine
    case Getankt
    case Gewartet
    
    var id: String { UUID().uuidString }
}

func getVehicleIcon(vehicleTyp: VehicleEnum) -> String {
    switch vehicleTyp {
    case .Ferrari:
        return "Ferrari"
    case .Porsche:
        return "Porsche"
    case .VW:
        return "VW"
    case .DS:
        return "Topic 2"
    case .MX5:
        return "Topic 2"
    }
}

func getVehicleBackground(vehicleTyp: VehicleEnum) -> String {
    switch vehicleTyp {
    case .Ferrari:
        return "Background 4"
    case .Porsche:
        return "Background 8"
    case .VW:
        return "Background 5"
    case .DS, .MX5:
        return "Background 10"
    }
}

