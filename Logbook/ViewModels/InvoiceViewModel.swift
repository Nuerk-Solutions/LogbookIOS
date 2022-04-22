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
    
    @Published var invoiceList: [InvoiceModel] = []
    
    let session: Session
    let interceptor: RequestInterceptor = Interceptor()
    
    init() {
        session = Session(interceptor: interceptor)
    }
    @MainActor
    func fetchInvoice(drivers: [DriverEnum], vehicles: [VehicleEnum], startDate: Date, detailed: Bool) async {
        let url = "https://europe-west1-logbookbackend.cloudfunctions.net/api/logbook/stats/driver?vehicles=\(vehicles.map{ $0.rawValue }.joined(separator: ",") )&drivers=\(drivers.map{ $0.rawValue }.joined(separator: ","))&startDate=\(DateFormatter.yearMonthDay.string(from: startDate))&detailed=\(detailed)&api-key=ca03na188ame03u1d78620de67282882a84"
        print(url)
        showAlert = false
        errorMessage = nil
        withAnimation {
            isLoading.toggle()
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.standardT)
        //            logbooks = try await apiService.getJSON(dateDecodingStrategy: .formatted(dateFormatter))
//        
//        AF.request(url, method: .get)
//            .responseData { response in
//                switch response.result {
//                case .success(let data):
//                    print("===")
//                    print("SUCCESS", data)
//                    print("===")
//                    
//                case .failure(let error):
//                    print("=======")
//                    print("ERROR", error)
//                    print("=======")
//                }
//            }
//            .responseString { data in
//                print("STRING:", data)
//            }
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
                print("====")
                print(response.error)
                withAnimation {
                    self.invoiceList = response.value ?? []

                    print(self.invoiceList)
                }
            }
    }
}
