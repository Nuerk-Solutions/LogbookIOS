//
//  InvoiceVehicleDetailView.swift
//  Logbook
//
//  Created by Thomas on 24.04.22.
//

import SwiftUI

struct InvoiceVehicleDetailView: View {
    
    var invoiceModel: InvoiceVehicleStats
    
    var body: some View {
        Form {
            Section {
                InvoiceDetailSectionComponent(name: "Zurückgelete Strecke", distance: invoiceModel.distance)
                InvoiceDetailSectionComponent(name: "Gesamte Fahrtkosten", cost: invoiceModel.distanceCost)
                InvoiceDetailSectionComponent(name: "Anzahl Tankungen", text: "\(invoiceModel.totalRefuels + 1)")
                if(invoiceModel.averageMaintenanceCostPerKm != nil) {
                InvoiceDetailSectionComponent(name: "Wartungskosten pro km", cost: invoiceModel.averageMaintenanceCostPerKm)
                }
            }
            
            Section {
                InvoiceDetailSectionComponent(name: "Verbrauch", text: String(format: "%.2f L", invoiceModel.averageConsumptionSinceLastRefuel))
                InvoiceDetailSectionComponent(name: "Kosten pro km", cost: invoiceModel.averageCostPerKmSinceLastRefuel, digits: 3)
            } header: {
                Text("Verbrauch - Letzte Tankung")
            }
            
            Section {
                InvoiceDetailSectionComponent(name: "Verbrauch", text: String(format: "%.2f L", invoiceModel.averageConsumption))
                InvoiceDetailSectionComponent(name: "Kosten pro km", cost: invoiceModel.averageCost, digits: 3)
            } header: {
                Text("Verbrauch - Gesamt")
            }
        }
        .navigationTitle(invoiceModel.vehicle.rawValue)
    }
}

struct InvoiceVehicleDetailView_Previews: PreviewProvider {
    static var previews: some View {
        InvoiceVehicleDetailView(invoiceModel: InvoiceVehicleStats(vehicle: .Ferrari, distance: 20, distanceCost: 20, averageConsumptionSinceLastRefuel: 20, averageCostPerKmSinceLastRefuel: 0.12626262626262627, averageConsumption: 20, averageCost: 20, totalRefuels: 2))
    }
}
