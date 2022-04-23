//
//  InvoiceViewModel.swift
//  Logbook
//
//  Created by Thomas on 22.04.22.
//

import Foundation
import SwiftUI
import Alamofire

class InvoiceViewModel: ObservableObject {
    
    @Published var showAlert = false
    @Published var errorMessage: String?
    @Published var isLoading = false
    @Published var invoiceSuccessful = false
    
    @Published var invoiceList: [InvoiceModel] = []
    
    let session: Session
    let interceptor: RequestInterceptor = Interceptor()
    
    init() {
        session = Session(interceptor: interceptor)
    }
    @MainActor
    func fetchInvoice(drivers: [DriverEnum], vehicles: [VehicleEnum], startDate: Date, endDate: Date, detailed: Bool) async {
        let url = "https://europe-west1-logbookbackend.cloudfunctions.net/api/logbook/stats/driver?vehicles=\(vehicles.map{ $0.rawValue }.joined(separator: ",") )&drivers=\(drivers.map{ $0.rawValue }.joined(separator: ","))&startDate=\(DateFormatter.yearMonthDay.string(from: startDate))&endDate=\(DateFormatter.yearMonthDay.string(from: endDate))&detailed=\(detailed)"
        showAlert = false
        errorMessage = nil
        withAnimation {
            isLoading.toggle()
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.standardT)
        session.request(url, method: .get)
            .validate(statusCode: 200..<201)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case.failure(let error):
                    switch response.response?.statusCode {
                    default:
                        self.errorMessage = error.localizedDescription
                        self.showAlert = true
                        self.isLoading = false
                        print("error fetch all", error)
                        break
                    }
                    print(error)
                case.success(let data):
                    print("Sucess Fetch All:", data)
                    withAnimation {
                        self.isLoading.toggle()
                    }
                    break
                }
            }
            .responseDecodable(of: [InvoiceModel].self, decoder: decoder) { (response) in
                withAnimation {
                    self.invoiceList = response.value ?? []
                }
            }
    }
    
    
    @MainActor
    func createInvoice(drivers: [DriverEnum], endDate: Date) async {
        let url = "https://europe-west1-logbookbackend.cloudfunctions.net/api/logbook/invoice/create/?drivers=\(drivers.map{ $0.rawValue }.joined(separator: ","))"
        showAlert = false
        errorMessage = nil
        withAnimation {
            isLoading.toggle()
        }
        
        let parameters: [String: String] = [
            "endDate": DateFormatter.yearMonthDay.string(from: endDate),
        ]
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.standardT)
        session.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder(encoder: JSONEncoder()))
            .validate(statusCode: 200...203)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case.failure(let error):
                    switch response.response?.statusCode {
                    default:
                        self.errorMessage = error.localizedDescription
                        self.showAlert = true
                        self.isLoading = false
                        print("error fetch all", error)
                        break
                    }
                    print(error)
                case.success(let data):
                    print("Sucess Fetch All:", data)
                    withAnimation {
                        self.isLoading.toggle()
                        self.invoiceSuccessful.toggle()
                    }
                    break
                }
            }
    }
}
