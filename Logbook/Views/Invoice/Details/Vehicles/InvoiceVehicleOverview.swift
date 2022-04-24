//
//  InvoiceVehicleOverview.swift
//  Logbook
//
//  Created by Thomas on 24.04.22.
//

import SwiftUI

struct InvoiceVehicleOverview: View {
    
    @EnvironmentObject var invoiceViewModel: InvoiceViewModel
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 200))], spacing: 15) {
            ForEach($invoiceViewModel.vehicleList, id: \.vehicle) {item in
                NavigationLink {
                    if !invoiceViewModel.isLoading {
                        InvoiceVehicleDetailView(invoiceModel: invoiceViewModel.vehicleList.first(where: {$0.vehicle == item.vehicle.wrappedValue})!)
                    }
                } label: {
                    VStack {
                        Text(item.vehicle.id)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 50)
                            .background(invoiceViewModel.isLoading ? .thinMaterial : .regularMaterial)
                            .foregroundColor(.primary)
                            .shadow(radius: 0)
                    }
                }.shadow(radius: 5)
                .disabled(invoiceViewModel.isLoading)
            }
        }
        .padding()
    }
}

struct InvoiceVehicleOverview_Previews: PreviewProvider {
    static var previews: some View {
        InvoiceVehicleOverview()
            .environmentObject(InvoiceViewModel())
    }
}
