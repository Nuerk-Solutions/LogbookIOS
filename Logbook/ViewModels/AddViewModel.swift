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
    
    func fetchLatestLogbooks() {
        showAlert = false
        errorMessage = nil
        withAnimation {
            isLoading.toggle()
        }
        
        defer {
            withAnimation {
                isLoading.toggle()
            }
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.standardT)
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
                        printError(description: "Fetch Latest", errorMessage: error.errorDescription)
                        print("Error fetch single")
                        print(error)
                        break
                    }
                    print(error)
                case.success(_):
                    consoleManager.print("Fetch latest logbooks")
                    break
                }
            }
            .responseDecodable(of: [LogbookModel].self, decoder: decoder) { response in
                withAnimation {
                    self.latestLogbooks = response.value ?? []
                }
            }
    }
    
    func submitLogbook(logbook: LogbookModel) {
        self.submitted = false
        showAlert = false
        errorMessage = nil
        
        withAnimation {
            isLoading.toggle()
        }
        
        defer {
            withAnimation {
                isLoading.toggle()
            }
        }
        
        let encoder: JSONEncoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(.standardT)
        
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.standardT)
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
                        printError(description: "Submit logbook", errorMessage: error.errorDescription)
                        print("Error post", error)
                        break
                    }
                    print(error)
                case.success(let data):
                    print("Sucess Post:", data)
                    consoleManager.print("Submitted logbook")
                    self.isLoading.toggle()
                    self.submitted.toggle()
                    break
                }
            }
    }
    
    func updateLogbook(logbook: LogbookModel) {
        self.submitted = false
        showAlert = false
        errorMessage = nil
        
        withAnimation {
            isLoading.toggle()
        }
        
        defer {
            withAnimation {
                isLoading.toggle()
            }
        }
        
        let encoder: JSONEncoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(.standardT)
        
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.standardT)
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
                        printError(description: "Update logbook", errorMessage: error.errorDescription)
                        print("Error post", error)
                        break
                    }
                    print(error)
                case.success(let data):
                    print("Sucess Patch:", data)
                    consoleManager.print("Updated logbook")
                    self.isLoading.toggle()
                    self.submitted.toggle()
                    break
                }
            }
    }
}
