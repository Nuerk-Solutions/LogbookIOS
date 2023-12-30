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
        self.driver = DriverEnum.Andrea
        self.vehicle = VehicleEnum.VW
        self.date = Date()
        self.reason = "Stadtfahrt"
        self.mileAge = MileAge()
        self.details = Details()
    }
    
    let id = UUID()
    
    let _id: String?
    var driver: DriverEnum
    var vehicle: VehicleEnum
    var date: Date
    var reason: String
    var mileAge: MileAge
    var details: Details
    var refuel: Refuel?
    var service: Service?
}

struct Service: Codable, Equatable {
    
    init() {
        self.message = ""
        self.price = 0
    }
    
    var message: String
    var price: Decimal
}

struct Refuel: Codable, Equatable {
    
    init() {
        self.liters = 0
        self.price = 0
        self.isSpecial = false
    }
    
    var liters: Decimal
    var price: Decimal
    var distanceDifference: Decimal?
    var consumption: Decimal?
    var isSpecial: Bool
}

struct Details: Codable, Equatable {
    
    init() {
        self.covered = false
    }
    
    var covered: Bool
    var driver: DriverEnum?
    var code: String?
    var notes: String?
}

struct MileAge: Codable, Equatable {
    
    init() {
        self.current = 0
        self.new = 0
        self.unit = UnitEnum.Km
    }
    var current: Decimal
    var new: Decimal
    var unit: UnitEnum
    var difference: Decimal?
    var cost: Decimal?
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

enum UnitEnum: String, CaseIterable, Codable, Identifiable {
    case Km = "km"
    case Mile = "mile"
    
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
            return "„Super 95 E5“ - WICHTIG ist hier führt das „E5“ , „E10“ zu Schäden"
        case .VW:
            return "Nur Diesel"
        case .Porsche, .DS:
            return "Super Plus 98 E5, WICHTIG ist hier die (mindestens) „98“. (manchmal fehlt auch die Angabe „E5“, weil es bei „98“ eh nur „E5“ gibt)"
        }
    }
    
    /*
     E-Mail vom 28.12.2023
     Bei Fehl-Betankungen:
     —> Tanken von Benzin bei Diesel-Autos und von Diesel bei Benzin-Autos führt zu massiven Defekten. Wenn man es bemerkt hat sofort Motor abstellen bzw besser gar nicht erst starten. Per Abschleppfahrzeug in die Werkstatt.
     —> Tanken der falschen Benzinsorte (95, 98, E5, E10…) bei Benzinautos: hier kann man in der Regel vorsichtig fahren (kein Vollgas, vor allem keine Höchstgeschwindigkeit auf der Autobahn), bis der Tank z.B. halbleer ist, und dann mit der richtigen Sorte wieder auffüllen, so vermischt sich das richtige Benzin mit der falschen Sorte und „verdünnt“ diese. Wenn versehentlich E10 getankt wurde: wenn vollgetankt wurde: umgehend nach Hause fahren und Tank per Schlauch möglichst weit absaugen, dann so weiter so verfahren wie im nächsten Satz beschrieben. Wenn nicht vollgetankt wurde: umgehend mit Shell-VPower100, Aral Ultimate 102 oder ähnlichem auffüllen, diese verdünnen das „E10“ gut.
     */
    
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

