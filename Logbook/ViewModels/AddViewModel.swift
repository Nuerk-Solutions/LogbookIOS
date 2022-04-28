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
        session.request("https://europe-west1-logbookbackend.cloudfunctions.net/api/logbook/\(logbook._id)", method: .patch, parameters: logbook, encoder: JSONParameterEncoder(encoder: encoder))
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
                    self.submitted.toggle()
                    break
                }
            }
    }
    
    func deleteLogbook(id: String) {
        self.showAlert = false
        self.errorMessage = nil
        self.deleted = false
        withAnimation {
            isLoading.toggle()
        }
        
        defer {
            withAnimation {
                isLoading.toggle()
            }
        }
        session.request("https://europe-west1-logbookbackend.cloudfunctions.net/api/logbook/\(id)", method: .delete)
            .validate(statusCode: 200..<300) // Response code need to be 204 NO_CONTENT
            .responseData { response in
                switch response.result {
                case.failure(let error):
                    switch response.response?.statusCode {
                    default:
                        self.errorMessage = error.localizedDescription
                        self.showAlert = true
                        printError(description: "Delete logbook", errorMessage: error.asAFError.debugDescription)
                        print("Error post", error)
                        break
                    }
                    print(error)
                case.success(_):
                    print("Sucessful delted:", id)
                    consoleManager.print("Delted logbook")
                    withAnimation {
                        self.deleted = true
                    }
                    break
                }
            }
    }
}
