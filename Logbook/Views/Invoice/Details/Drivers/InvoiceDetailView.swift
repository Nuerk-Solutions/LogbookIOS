//
//  InvoiceDetailView.swift
//  Logbook
//
//  Created by Thomas on 22.04.22.
//

import SwiftUI

struct InvoiceDetailView: View {
    
    let invoiceModel: InvoiceModel
    
    var body: some View {
        Form {
            Section {
                InvoiceDetailSectionComponent(name: "Gefahrene Strecke", distance: invoiceModel.distance)
                InvoiceDetailSectionComponent(name: "Fahrtkosten", cost: invoiceModel.distanceCost)
                if (invoiceModel.drivesCostForFree != nil) {
                    InvoiceDetailSectionComponent(name: "Übernommene Kosten", cost: invoiceModel.drivesCostForFree!)
                        .listRowBackground(Color.orange)
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
                                    .listRowBackground(Color.orange)
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

struct InvoiceDetailView_Previews: PreviewProvider {
    static var previews: some View {
        InvoiceDetailView(invoiceModel: InvoiceModel.single)
    }
}
