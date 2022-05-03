//
//  InvoiceDetailView.swift
//  Logbook
//
//  Created by Thomas on 22.04.22.
//

import SwiftUI

struct InvoiceDriverDetailView: View {
    
    let invoiceModel: InvoiceModel
    
    var body: some View {
        Form {
            Section {
                InvoiceDetailSectionComponent(name: "Gefahrene Strecke", distance: invoiceModel.distance)
                InvoiceDetailSectionComponent(name: "Fahrtkosten", cost: invoiceModel.distanceCost)
                if (invoiceModel.drivesCostForFree != nil) {
                    InvoiceDetailSectionComponent(name: "Übernommene Kosten", cost: invoiceModel.drivesCostForFree!)
                        .listRowBackground(Color.gray.opacity(0.1))
                }
            } header: {
                Text("Gesamtnachweis")
            } footer: {
                Text("Die übernommen Fahrtkosten werden automatisch mit den Fahrtkosten von Claudia verrechnet.")
            }
            
            Section {
                ForEach(invoiceModel.vehicles, id: \.vehicleTyp) { item in
                    Section {
                        DisclosureGroup(content: {
                            InvoiceDetailSectionComponent(name: "Gefahrene Strecke", distance: item.distance)
                            InvoiceDetailSectionComponent(name: "Fahrtkosten", cost: item.distanceCost)
                            if (item.drivesCostForFree != nil) {
                                InvoiceDetailSectionComponent(name: "Übernommene Kosten", cost: item.drivesCostForFree!)
                                    .listRowBackground(Color.gray.opacity(0.05))
                            }
                        }, label: {
                            Text(item.vehicleTyp.id)
                                .font(.headline)
                        })
                    }
                }
            } header: {
                Text("Einzelnachweis")
            }
            
        }
        .navigationTitle(invoiceModel.driver.rawValue)
    }
}

struct InvoiceDriverDetailView_Previews: PreviewProvider {
    static var previews: some View {
        InvoiceDriverDetailView(invoiceModel: InvoiceModel.single)
    }
}
