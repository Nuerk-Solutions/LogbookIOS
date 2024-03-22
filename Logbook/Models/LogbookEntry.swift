//
//  LogbookEntry.swift
//  Logbook
//
//  Created by Thomas on 26.05.22.
//

import Foundation
import Alamofire
import SwiftUI

struct LogbookEntry: Codable, Identifiable, Equatable {
    
    init(mileAge: MileAge = MileAge()) {
        self._id = nil
        self.driver = DriverEnum.Andrea
        self.vehicle = VehicleEnum.Ferrari
        self.date = Date()
        self.reason = "Stadtfahrt"
        self.mileAge = mileAge
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
    var animated: Bool? = false
}


public struct Service: Codable, Equatable {
    
    init() {
        self.message = ""
        self.price = 0
    }
    
    var message: String
    var price: Double
}

public struct Refuel: Codable, Equatable {
    
    init(liters: Double = 0, price: Double = 0, isSpecial: Bool = false) {
        self.liters = liters
        self.price = price
        self.isSpecial = isSpecial
    }
    
    var liters: Double
    var price: Double
    var distanceDifference: Double?
    var consumption: Double?
    var isSpecial: Bool
    var previousRecordID: String?
}

struct Details: Codable, Equatable {
    
    init() {
        self.covered = false
    }
    
    var covered: Bool
    var driver: DriverEnum?
    var voucher: VoucherResponse?
    var notes: String?
}

struct MileAge: Codable, Equatable {
    
    init(current: Int = 0, new: Int = 0) {
        self.current = current
        self.new = new
        self.unit = UnitEnum.KM
    }
    var current, new: Int
    var unit: UnitEnum
    var difference: Int?
    var cost: Double?
}

extension LogbookEntry {
    
    static var previewData: LogbookAPIResponse {
        let previewDataURL = Bundle.main.url(forResource: "logbooks", withExtension: "json")!
        let data = try! Data(contentsOf: previewDataURL)
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(.iso8601Full)
        
        let apiResponse = try! jsonDecoder.decode(LogbookAPIResponse.self, from: data)
        
        return apiResponse
    }
    
    var isSubmittable: Bool {
        self.mileAge.new > self.mileAge.current && !self.reason.isEmpty
    }
    
    var distance: Double {
        Double(self.mileAge.new - self.mileAge.current)
    }
    
    var computedDistance: Double {
        distance * self.mileAge.unit.distanceMultiplier
    }
    
    func voucherRemainingDistance(voucher: Voucher) -> Double {
        let dist = self.computedDistance - Double(voucher.remainingDistance)
        if dist < 0 {
            return 0.0
        }
        return dist
    }
    
    var hasAddInfo: Bool {
        self.service != nil || self.refuel != nil
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
    case KM = "km"
    case MILE = "mile"
    
    
    var name: String {
        switch self {
        case .KM:
            return "km"
        case .MILE:
            return "mi"
        }
    }
    
    var fullName: String {
        switch self {
        case .KM:
            return "Kilometerstand"
        case .MILE:
            return "Meilenstand"
        }
    }
    
    
    var distanceMultiplier: Double {
        self == .KM ? 1 : 1.60934
    }
    
    var id: String { UUID().uuidString }
}


enum VehicleEnum: String, CaseIterable, Identifiable, Codable, Equatable {
    case Ferrari
    case VW
    case Porsche
    case MX5
    case DS
    
    var fuelTyp: [FuelTyp] {
        switch self {
        case .Ferrari, .MX5:
            return [.SUPER_95_E5, .SUPER_PLUS_98_E5, .SP_VP_AU]
            //return .SUPER_95_E5
        case .VW:
            return [.DIESEL]
            //return .DIESEL
        case .Porsche, .DS:
            return [.SUPER_PLUS_98_E5, .SP_VP_AU]
            //return .SUPER_95_E10
        }
    }
    
    var preferedFuelTyp: FuelTyp {
        switch self {
        case .Ferrari, .MX5:
            return .SUPER_95_E5
        case .VW:
            return .DIESEL
        case .Porsche, .DS:
            return .SUPER_PLUS_98_E5
        }
    }
    
    var unit: UnitEnum {
        return self != .MX5 ? .KM : .MILE
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

func getVehicleIcon(vehicleTyp: VehicleEnum) -> String {
    switch vehicleTyp {
    case .Ferrari:
        return "Ferrari"
    case .Porsche:
        return "Porsche"
    case .VW:
        return "VW"
    case .DS:
        return "DS"
    case .MX5:
        return "MX5"
    }
}

func getVehicleBackgroundColor(vehicleTyp: VehicleEnum) -> Color {
    switch vehicleTyp {
    case .Ferrari:
        return Color.red.opacity(0.2)
    case .Porsche:
        return Color.black.opacity(0.3)
    case .VW:
        return Color.gray.opacity(0.1)
    case .DS:
        return Color.brown.opacity(0.2)
    case .MX5:
        return Color.blue.opacity(0.1)
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


func getLogbookForVehicle(lastLogbooks: [LogbookEntry], vehicle: VehicleEnum) -> LogbookEntry? {
    lastLogbooks.first { entry in
        entry.vehicle == vehicle
    }
}
