//
//  DetailListViewModel.swift
//  Logbook
//
//  Created by Thomas on 05.01.22.
//

import Foundation
import SwiftUI
import Alamofire

class DetailViewModel: ObservableObject {
    
    @Published var detailedLogbook: LogbookModel?
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var errorMessage: String?
    
    let session: Session
    let interceptor: RequestInterceptor = Interceptor()
    
    init() {
        session = Session(interceptor: interceptor)
    }
    
    func fetchLogbookById(logbookId: String?) {
        showAlert = false
        errorMessage = nil
        if let logbookId = logbookId {
            
            withAnimation {
                isLoading.toggle()
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(.standardT)
            session.request("https://api.nuerk-solutions.de/logbook/find/\(logbookId)", method: .get)
                .validate()
                .responseData { response in
                    switch response.result {
                    case.failure(let error):
                        switch response.response?.statusCode {
                        default:
                            self.errorMessage = error.localizedDescription
                            self.showAlert = true
                            print("error fetch all", error)
                            printError(description: "Detailed fetch", errorMessage: error.localizedDescription)
                            break
                        }
                        print(error)
                    case.success( _):
                        consoleManager.print("Fetched detailed data for ID: \(logbookId)")
                        break
                    }
                }
                .responseDecodable(of: LogbookModel.self, decoder: decoder) { (response) in
                    withAnimation {
                        self.detailedLogbook = response.value
                    }
                    switch response.result {
                    case .failure(let error):
                        printError(description: "Detailed decoding", errorMessage: error.localizedDescription)
                        break
                    case .success(_):
                        consoleManager.print("Detailed data decoded!")
                        withAnimation {
                            self.isLoading = false
                        }
                        break
                    }
                }
        }
    }
}
