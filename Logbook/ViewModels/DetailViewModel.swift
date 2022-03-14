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
    
    @Published var logbook: LogbookModel?
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var errorMessage: String?
    var logbookId: String?
    
    let session: Session
    let interceptor: RequestInterceptor = Interceptor()
    
    init() {
        session = Session(interceptor: interceptor)
    }
    
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return dateFormatter
    }()
    
    @MainActor
    func fetchLogbookById() async {
        showAlert = false
        errorMessage = nil
        if let logbookId = logbookId {
            let apiService = APIService(urlString: "https://europe-west1-logbookbackend.cloudfunctions.net/api/logbook/find/\(logbookId)")
            isLoading.toggle()
            
            
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            //            logbooks = try await apiService.getJSON(dateDecodingStrategy: .formatted(dateFormatter))
            print(logbookId)
            session.request("https://europe-west1-logbookbackend.cloudfunctions.net/api/logbook/find/\(logbookId)", method: .get)
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
                        self.isLoading.toggle()
                        break
                    }
                }
                .responseDecodable(of: LogbookModel.self, decoder: decoder) { (response) in
                    print(response)
                    self.logbook = response.value!
                }
            
            
//            defer { // Defer means that is executed after all is finished
//                isLoading.toggle()
//            }
            
//            do {
//                logbook = try await apiService.getJSON()
//            } catch {
//                showAlert = true
//                errorMessage = error.localizedDescription + "\nBitte melde dich bei weiteren Problem bei Thomas."
//            }
        }
    }
}
