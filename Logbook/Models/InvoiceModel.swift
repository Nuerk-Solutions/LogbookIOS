//
//  InvoiceModel.swift
//  Logbook
//
//  Created by Thomas on 22.04.22.
//

import Foundation

struct InvoiceModel: Codable {
    var driver: DriverEnum
    var distance: Int
    var distanceCost: Double
    var vehicles: [InvoiceVehicle]
    var drivesCostForFree: Double?
}

struct InvoiceVehicle: Codable {
    var vehicleTyp: VehicleEnum
    var distance: Int
    var distanceCost: Double
    var drivesCostForFree: Double?
}

// TODO: Sync naming

struct InvoiceVehicleStats: Codable {
    var vehicle: VehicleEnum
    var distance: Int
    var distanceCost: Double
    var averageConsumptionSinceLastRefuel: Double
    var averageCostPerKmSinceLastRefuel: Double?
    var averageMaintenanceCostPerKm: Double?
    var averageConsumption: Double
    var averageCost: Double
    var totalRefuels: Int
}

struct InvoiceHistory: Codable {
    var date: Date
}

extension InvoiceModel {
    static let array: [InvoiceModel] = [
        InvoiceModel(driver: .Andrea, distance: 20, distanceCost: 22, vehicles: [InvoiceVehicle(vehicleTyp: .Ferrari, distance: 20, distanceCost: 20), InvoiceVehicle(vehicleTyp: .VW, distance: 2, distanceCost: 2)]),
        InvoiceModel(driver: .Claudia, distance: 20, distanceCost: 22, vehicles: [InvoiceVehicle(vehicleTyp: .Ferrari, distance: 20, distanceCost: 20), InvoiceVehicle(vehicleTyp: .VW, distance: 2, distanceCost: 2)]),
        InvoiceModel(driver: .Oliver, distance: 20, distanceCost: 22, vehicles: [InvoiceVehicle(vehicleTyp: .Ferrari, distance: 20, distanceCost: 20), InvoiceVehicle(vehicleTyp: .VW, distance: 2, distanceCost: 2)]),
        InvoiceModel(driver: .Thomas, distance: 20, distanceCost: 22, vehicles: [InvoiceVehicle(vehicleTyp: .Ferrari, distance: 20, distanceCost: 20), InvoiceVehicle(vehicleTyp: .VW, distance: 2, distanceCost: 2)])
    ]
    
    static let single: InvoiceModel = InvoiceModel(driver: .Claudia, distance: 25, distanceCost: 3, vehicles: [InvoiceVehicle(vehicleTyp: .Ferrari, distance: 20, distanceCost: 20, drivesCostForFree: 5),InvoiceVehicle(vehicleTyp: .VW, distance: 20, distanceCost: 20),InvoiceVehicle(vehicleTyp: .Porsche, distance: 20, distanceCost: 20, drivesCostForFree: 2)], drivesCostForFree: 7)
}
