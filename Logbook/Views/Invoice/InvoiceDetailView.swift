//
//  InvoiceDetailView.swift
//  Logbook
//
//  Created by Thomas on 22.04.22.
//

import SwiftUI

struct InvoiceDetailView: View {
    
    let driver: DriverEnum
    @EnvironmentObject var invoiceViewModel: InvoiceViewModel
    
    
    var body: some View {
        Form {
            if invoiceViewModel.invoiceList.first != nil {
            Section {
                HStack {
                    Text("Gefahrene Strecke")
                    Spacer()
                    Text("\(invoiceViewModel.invoiceList.first!.distance)km")
                }
                HStack {
                    Text("Fahrtkosten")
                    Spacer()
                    Text("\(invoiceViewModel.invoiceList.first!.distanceCost)€")
                }
                if (invoiceViewModel.invoiceList.first!.drivesCostForFree != nil) {
                HStack {
                    Text("Übernomme Fahrtkosten")
                    Spacer()
                    Text("\(invoiceViewModel.invoiceList.first!.drivesCostForFree!)€")
                }
                }
            } header: {
                Text("Gesamt")
            }
            }
            
            
            if (invoiceViewModel.invoiceList.first?.vehicles.ferrari != nil) {
                Section {
                    HStack {
                        Text("Gefahrene Strecke")
                        Spacer()
                        Text("\(invoiceViewModel.invoiceList.first!.vehicles.ferrari!.distance)km")
                    }
                    HStack {
                        Text("Fahrtkosten")
                        Spacer()
                        Text("\(invoiceViewModel.invoiceList.first!.vehicles.ferrari!.distanceCost)€")
                    }
                } header: {
                    Text("Ferrari")
                }
                
            }
            if((invoiceViewModel.invoiceList.first?.vehicles.vw) != nil) {
                
                Section {
                    HStack {
                        Text("Gefahrene Strecke")
                        Spacer()
                        Text("\(invoiceViewModel.invoiceList.first!.vehicles.vw!.distance)km")
                    }
                    HStack {
                        Text("Fahrtkosten")
                        Spacer()
                        Text("\(invoiceViewModel.invoiceList.first!.vehicles.vw!.distanceCost)€")
                    }
                } header: {
                    Text("VW")
                }
            }
            if((invoiceViewModel.invoiceList.first?.vehicles.porsche) != nil) {
                
                Section {
                    HStack {
                        Text("Gefahrene Strecke")
                        Spacer()
                        Text("\(invoiceViewModel.invoiceList.first!.vehicles.porsche!.distance)km")
                    }
                    HStack {
                        Text("Fahrtkosten")
                        Spacer()
                        Text("\(invoiceViewModel.invoiceList.first!.vehicles.porsche!.distanceCost)€")
                    }
                } header: {
                    Text("Porsche")
                }
                //                ForEach(invoiceViewModel.invoiceList.first?, id: \.self) { item in
                //                    Section {
                //                        HStack {
                //                            Text("Gefahrene Strecke")
                //                            Spacer()
                ////                            Text(item.distance)
                //                        }
                //                        HStack {
                //                            Text("Fahrtkosten")
                //                            Spacer()
                ////                            Text(item.distanceCost)
                //                        }
                //                    } header: {
                //                        Text("TEST")
                //                    }
                
            }
        }
        .navigationTitle(driver.rawValue)
        .overlay {
            if invoiceViewModel.isLoading {
                ProgressView()
            }
            
        }
        .task {
            //            #if !DEBUG
            await invoiceViewModel.fetchInvoice(drivers: [driver], vehicles: VehicleEnum.allCases, startDate: DateFormatter.yearMonthDay.date(from: "2021-01-01")!, detailed: true)
            //            #endif
        }
    }
}

struct InvoiceDetailView_Previews: PreviewProvider {
    static var previews: some View {
        InvoiceDetailView(driver: .Andrea)
    }
}
