//
//  LogbookViewModel.swift
//  Logbook
//
//  Created by Thomas on 16.12.21.
//

import Foundation
import SwiftUI
import Alamofire

class AddViewModel: ObservableObject {
    
    @Published var latestLogbooks: [LogbookModel]?
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var errorMessage: String?
    @Published var submitted = false
    
    
    let session: Session
    let interceptor: RequestInterceptor = Interceptor()
    
    init() {
        session = Session(interceptor: interceptor)
    }
    @MainActor
    func fetchLatestLogbooks() async {
        showAlert = false
        errorMessage = nil
        //        let apiService = APIService(urlString: "https://europe-west1-logbookbackend.cloudfunctions.net/api/logbook/find/latest")
        
        withAnimation {
            isLoading.toggle()
        }
        
        //        defer {
        //            isLoading.toggle()
        //        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.standardT)
        //            logbooks = try await apiService.getJSON(dateDecodingStrategy: .formatted(dateFormatter))
        session.request("https://europe-west1-logbookbackend.cloudfunctions.net/api/logbook/find/latest", method: .get)
            .validate(statusCode: 200..<201)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case.failure(let error):
                    switch response.response?.statusCode {
                    default:
                        self.errorMessage = error.localizedDescription
                        self.showAlert = true
                        print("Error fetch single")
                        print(error)
                        break
                    }
                    print(error)
                case.success(let data):
                    print("Sucess fetch Single:", data)
                    withAnimation {
                        self.isLoading.toggle()
                    }
                    break
                }
            }
            .responseDecodable(of: [LogbookModel].self, decoder: decoder) { response in
                withAnimation {
                    self.latestLogbooks = response.value ?? []
                }
            }
    }
    
    @MainActor
    func submitLogbook(logbook: LogbookModel) async {
        self.submitted = false
        
        isLoading.toggle()
        
        //        defer {
        //            isLoading.toggle()
        //        }
        
        let encoder: JSONEncoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(.standardT)
        
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.standardT)
        //            logbooks = try await apiService.getJSON(dateDecodingStrategy: .formatted(dateFormatter))
        session.request("https://europe-west1-logbookbackend.cloudfunctions.net/api/logbook", method: .post, parameters: logbook, encoder: JSONParameterEncoder(encoder: encoder))
            .validate(statusCode: 200..<202) // Response code need to be 201
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case.failure(let error):
                    switch response.response?.statusCode {
                    default:
                        self.errorMessage = error.localizedDescription
                        self.showAlert = true
                        print("Error post", error)
                        break
                    }
                    print(error)
                case.success(let data):
                    print("Sucess Post:", data)
                    self.isLoading.toggle()
                    self.submitted.toggle()
                    break
                }
            }.responseString { result in
                print(String(data: result.data!, encoding: .utf8))
            }
        //            .responseDecodable(of: [LogbookModel].self, decoder: decoder) { response in
        //                self.latestLogbooks = response.value ?? []
        //            }
    }
    
    func updateLogbook(logbook: LogbookModel) {
        self.submitted = false
        
        isLoading.toggle()
        
        //        defer {
        //            isLoading.toggle()
        //        }
        
        let encoder: JSONEncoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(.standardT)
        
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.standardT)
        //            logbooks = try await apiService.getJSON(dateDecodingStrategy: .formatted(dateFormatter))
        session.request("https://europe-west1-logbookbackend.cloudfunctions.net/api/logbook", method: .patch, parameters: logbook, encoder: JSONParameterEncoder(encoder: encoder))
            .validate(statusCode: 200..<202) // Response code need to be 201
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case.failure(let error):
                    switch response.response?.statusCode {
                    default:
                        self.errorMessage = error.localizedDescription
                        self.showAlert = true
                        print("Error post", error)
                        break
                    }
                    print(error)
                case.success(let data):
                    print("Sucess Patch:", data)
                    self.isLoading.toggle()
                    self.submitted.toggle()
                    break
                }
            }.responseString { result in
                print(String(data: result.data!, encoding: .utf8))
            }
        //            .responseDecodable(of: [LogbookModel].self, decoder: decoder) { response in
        //                self.latestLogbooks = response.value ?? []
        //            }
    }
}
