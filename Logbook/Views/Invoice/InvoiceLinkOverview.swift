//
//  InvoiceLinkOverview.swift
//  Logbook
//
//  Created by Thomas on 03.05.22.
//

import SwiftUI

struct InvoiceLinkOverview: View {
    
    @Binding var driver: DriverEnum?
    @Binding var startDate: Date?
    @Binding var endDate: Date?
    
    @StateObject private var listViewModel = ListViewModel()
    
    let readableDateFormat: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.locale = Locale(identifier: "de")
        return dateFormatter
    }()
    
    // logbookapp://Andrea/2022-01-01/2022-01-05
    
    var body: some View {
        NavigationView {
        List {
            ForEach($listViewModel.invoiceLogbooks) { $logbook in
                HStack {
                    Image(logbook.vehicleTyp == .VW ? "car_vw" : logbook.vehicleTyp == .Ferrari ? "logo_small" : "porsche")
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(logbook.vehicleTyp == .Porsche ? 1.2 : 1)
                        .frame(width: 80, height: 75)
                        .offset(y: logbook.vehicleTyp == .Porsche ? -5 : 0)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(logbook.vehicleTyp == .VW ? Color.blue : logbook.vehicleTyp == .Ferrari ? Color.red : Color.gray, lineWidth: 1).opacity(0.5))
                    VStack(alignment: .leading) {
                        Text(logbook.driveReason)
                            .font(.headline)
                        Text(self.readableDateFormat.string(from: logbook.date))
                        Text(logbook.driver.id)
                            .font(.subheadline)
                    }.padding(.leading, 8)
                }.padding(.init(top: 6, leading: 0, bottom: 6, trailing: 0))
            }
        }
        .onAppear {
            listViewModel.fetchLogbooksForDriver(driver: driver!, startDate: startDate!, endDate: endDate!)
        }
        .overlay {
            if listViewModel.isLoadingInvoiceOverview {
                CustomProgressView(message: "Übersicht Laden...")
            }
        }
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismissToRoot()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30, alignment: .center)
                }

            }
        })
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Zusammenfassung")
        }
    }
}

struct InvoiceLinkOverview_Previews: PreviewProvider {
    static var previews: some View {
        InvoiceLinkOverview(driver: .constant(.Thomas), startDate: .constant(.now), endDate: .constant(.now))
    }
}
