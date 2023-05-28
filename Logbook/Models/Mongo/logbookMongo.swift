//
//  logbookMongo.swift
//  Logbook
//
//  Created by Thomas on 22.05.23.
//

import Foundation
import RealmSwift

class logbook: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId

    @Persisted var additionalInformation: String = ""

    @Persisted var additionalInformationCost: String = ""

    @Persisted var additionalInformationTyp: AdditionalInformationTypEnum = AdditionalInformationTypEnum.Keine

    @Persisted var currentMileAge: String = ""

    @Persisted var date: Date = Date()

    @Persisted var distance: String = ""

    @Persisted var distanceCost: String = ""

    @Persisted var distanceSinceLastAdditionalInformation: String = ""

    @Persisted var driveReason: String = ""

    @Persisted var driver: DriverEnum = DriverEnum.Andrea

    @Persisted var forFree: Bool?

    @Persisted var newMileAge: String = ""

    @Persisted var vehicleTyp: VehicleEnum = VehicleEnum.Ferrari
}


enum DriverEnum: String, CaseIterable, Codable, Identifiable, PersistableEnum {
    case Andrea
    case Claudia
    case Oliver
    case Thomas
    
    var id: String { UUID().uuidString }
}
enum VehicleEnum: String, CaseIterable, Identifiable, Codable, Equatable, PersistableEnum {
    case Ferrari
    case VW
    case Porsche
    
    var fuelTyp: FuelTyp {
        switch self {
        case .Ferrari:
            return .SUPER
        case .VW:
            return .DIESEL
        case .Porsche:
            return .SUPER_E10
        }
    }
    
    var fuelDescription: String {
        switch self {
        case .Ferrari:
            return "In den Ferrari wird nur e5 oder Super getankt."
        case .VW:
            return "In den VW wird nur Diesel getankt."
        case .Porsche:
            return "In den Porsche wird nur Super+ getankt."
        }
    }
    
    var id: String { UUID().uuidString }
}

enum AdditionalInformationTypEnum: String, Equatable, CaseIterable, Codable, Identifiable, PersistableEnum {
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
    }
}

