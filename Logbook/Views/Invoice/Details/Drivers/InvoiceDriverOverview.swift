//
//  InvoiceDriverOverview.swift
//  Logbook
//
//  Created by Thomas on 24.04.22.
//

import SwiftUI

struct InvoiceDriverOverview: View {
    
    @EnvironmentObject var invoiceViewModel: InvoiceViewModel
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 200))], spacing: 15) {
            ForEach($invoiceViewModel.invoiceList, id: \.driver) {item in
                NavigationLink {
                    if !invoiceViewModel.isLoading {
                        InvoiceDriverDetailView(invoiceModel: invoiceViewModel.invoiceList.first(where: {$0.driver == item.driver.wrappedValue}) ?? InvoiceModel.single)
                    }
                } label: {
                    VStack {
                        Text(item.driver.id)
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

struct InvoiceDriverOverview_Previews: PreviewProvider {
    static var previews: some View {
        InvoiceDriverOverview()
            .environmentObject(InvoiceViewModel())
    }
}
