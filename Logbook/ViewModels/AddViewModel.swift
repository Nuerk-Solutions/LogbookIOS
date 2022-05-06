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
    @Published var deleted = false
    
    
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
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.standardT)
        session.request("https://api.nuerk-solutions.de/logbook/find/latest", method: .get)
            .validate(statusCode: 200..<201)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case.failure(let error):
                    switch response.response?.statusCode {
                    default:
                        self.errorMessage = error.localizedDescription
                        self.showAlert = true
                        printError(description: "Fetch Latest", errorMessage: error.localizedDescription)
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
                    self.isLoading = false
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
        
        let encoder: JSONEncoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(.standardT)
        
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.standardT)
        session.request("https://api.nuerk-solutions.de/logbook", method: .post, parameters: logbook, encoder: JSONParameterEncoder(encoder: encoder))
            .validate(statusCode: 200..<202) // Response code need to be 201
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case.failure(let error):
                    switch response.response?.statusCode {
                    default:
                        self.errorMessage = error.localizedDescription
                        self.showAlert = true
                        printError(description: "Submit logbook", errorMessage: error.localizedDescription)
                        print("Error post", error)
                        break
                    }
                    print(error)
                case.success(let data):
                    print("Sucess Post:", data)
                    consoleManager.print("Submitted logbook")
                    self.submitted.toggle()
                    withAnimation {
                        self.isLoading = false
                    }
                    break
                }
            }
    }
    
    func updateLogbook(logbook: LogbookModel) {
        self.submitted = false
        showAlert = false
        errorMessage = nil
        
        withAnimation {
            isLoading = true
        }
        
        let encoder: JSONEncoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(.standardT)
        
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.standardT)
        session.request("https://api.nuerk-solutions.de/logbook/\(logbook._id)", method: .patch, parameters: logbook, encoder: JSONParameterEncoder(encoder: encoder))
            .validate(statusCode: 200..<202) // Response code need to be 201
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case.failure(let error):
                    switch response.response?.statusCode {
                    default:
                        self.errorMessage = error.localizedDescription
                        self.showAlert = true
                        printError(description: "Update logbook", errorMessage: error.localizedDescription)
                        print("Error post", error)
                        break
                    }
                    print(error)
                case.success(let data):
                    print("Sucess Patch:", data)
                    consoleManager.print("Updated logbook")
                    self.submitted.toggle()
                    withAnimation {
                        self.isLoading = false
                    }
                    break
                }
            }
    }
    
    func deleteLogbook(id: String) {
        self.showAlert = false
        self.errorMessage = nil
        self.deleted = false
        withAnimation {
            isLoading = true
        }
        session.request("https://api.nuerk-solutions.de/logbook/\(id)", method: .delete)
            .validate(statusCode: 200..<300) // Response code need to be 204 NO_CONTENT
            .responseData { response in
                switch response.result {
                case.failure(let error):
                    switch response.response?.statusCode {
                    default:
                        self.errorMessage = error.localizedDescription
                        self.showAlert = true
                        printError(description: "Delete logbook", errorMessage: error.localizedDescription)
                        print("Error post", error)
                        break
                    }
                    print(error)
                case.success(_):
                    print("Sucessful delted:", id)
                    consoleManager.print("Delted logbook")
                    withAnimation {
                        self.deleted = true
                        self.isLoading = false
                    }
                    break
                }
            }
    }
}
