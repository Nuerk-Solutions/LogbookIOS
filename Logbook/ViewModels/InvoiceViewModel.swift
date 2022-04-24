//
//  InvoiceViewModel.swift
//  Logbook
//
//  Created by Thomas on 22.04.22.
//

import Foundation
import SwiftUI
import Alamofire
import SPAlert

class InvoiceViewModel: ObservableObject {
    
    @Published var showAlert = false
    @Published var errorMessage: String?
    @Published var isLoading = false
    @Published var invoiceSuccessful = false
    @Published var invoiceHistory = [InvoiceHistory]()
    @Published var latestInvoiceDate = Date.distantPast
    
    @Published var invoiceList: [InvoiceModel] = []
    @Published var vehicleList: [InvoiceVehicleStats] = []
    
    let session: Session
    let interceptor: RequestInterceptor = Interceptor()
    
    init() {
        session = Session(interceptor: interceptor)
    }
    
    @MainActor
    func fetchInvoiceHistory() async {
        let url = "https://europe-west1-logbookbackend.cloudfunctions.net/api/logbook/invoice/history"
        showAlert = false
        errorMessage = nil
        withAnimation {
            isLoading = true
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
                        self.isLoading = false
                    }
                    break
                }
            }
            .responseDecodable(of: [InvoiceHistory].self, decoder: decoder) { (response) in
                withAnimation {
                    self.invoiceHistory = response.value?.sorted { $0.date > $1.date } ?? []
                    self.latestInvoiceDate = self.invoiceHistory.first?.date ?? Date.distantPast
                }
            }
    }
    
    @MainActor
    func fetchDriverStats(drivers: [DriverEnum], vehicles: [VehicleEnum], startDate: Date, endDate: Date, detailed: Bool) async {
        let endDateDay = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: endDate) ?? endDate
        let url = "https://europe-west1-logbookbackend.cloudfunctions.net/api/logbook/stats/driver?vehicles=\(vehicles.map{ $0.rawValue }.joined(separator: ",") )&drivers=\(drivers.map{ $0.rawValue }.joined(separator: ","))&startDate=\(DateFormatter.yearMonthDay.string(from: startDate))&endDate=\(DateFormatter.standardT.string(from: endDateDay))&detailed=\(detailed)"
        showAlert = false
        errorMessage = nil
        withAnimation {
            isLoading = true
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
                        self.isLoading = false
                    }
                    break
                }
            }
            .responseDecodable(of: [InvoiceModel].self, decoder: decoder) { (response) in
                withAnimation {
                    self.invoiceList = response.value?.sorted { $0.driver.rawValue < $1.driver.rawValue } ?? []
                }
            }
    }
    
    @MainActor
    func fetchVehicleStats(vehicles: [VehicleEnum], startDate: Date, endDate: Date) async {
        let endDateDay = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: endDate) ?? endDate
        let url = "https://europe-west1-logbookbackend.cloudfunctions.net/api/logbook/stats/vehicle?vehicles=\(vehicles.map{ $0.rawValue }.joined(separator: ","))&startDate=\(DateFormatter.yearMonthDay.string(from: startDate))&endDate=\(DateFormatter.standardT.string(from: endDateDay))&api-key=ca03na188ame03u1d78620de67282882a84"
        print(url)
        showAlert = false
        errorMessage = nil
        withAnimation {
            isLoading = true
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.standardT)
        
        AF.request(url, method: .get)
            .validate()
//            .validate(contentType: ["application/json"])
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
                    print("====================================")
                    withAnimation {
                        self.isLoading = false
                    }
                    break
                }
            }
            .responseDecodable(of: [InvoiceVehicleStats].self, decoder: decoder) { (response) in
                switch response.result {
                case.failure(let error):
                    print("===")
                    print(error)
                case .success(let data):
                    print("SUCESS VEHICLE")
                }
                print(response.value)
                withAnimation {
                    self.vehicleList = response.value?.sorted { $0.vehicle.rawValue < $1.vehicle.rawValue } ?? []
                }
            }
    }
    
    
    @MainActor
    func createInvoice(drivers: [DriverEnum], endDate: Date) async {
        let driverString = "?drivers=\(drivers.map{ $0.rawValue }.joined(separator: ","))"
        
        let url = "https://europe-west1-logbookbackend.cloudfunctions.net/api/logbook/invoice/create/\(!drivers.isEmpty ? driverString : "")"
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
            .validate()
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
                        SPAlertView(title: "Abrechnung erstellt", message: "", preset: .done).present(haptic: .success) {
                            Task {
                                await self.fetchInvoiceHistory()
                            }
                        }
                    }
                    break
                }
            }
    }
}
