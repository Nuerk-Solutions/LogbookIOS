//
//  InvoiceViewModel.swift
//  Logbook
//
//  Created by Thomas on 22.04.22.
//

import Foundation

class InvoiceViewModel: ObservableObject {
    
    @Published var invoiceList = InvoiceModel()
    
    func fetchInvoice(driver: DriverEnum, vehicle: VehicleEnum, startDate: Date) {
        
    }
}
