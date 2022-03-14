//
//  LogbookListViewModel.swift
//  Logbook
//
//  Created by Thomas on 05.01.22.
//

import Foundation
import SwiftUI
import Alamofire
class ListViewModel: ObservableObject {
    
    @Published var logbooks: [LogbookModel] = []
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var errorMessage: String?
    
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
    func fetchLogbooks() async {
        showAlert = false
        errorMessage = nil
        //        let apiService = APIService(urlString: "https://europe-west1-logbookbackend.cloudfunctions.net/api/logbook/find/all?sort=-date")
        
        isLoading.toggle()
        //        defer {
        //            isLoading.toggle()
        //        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        //            logbooks = try await apiService.getJSON(dateDecodingStrategy: .formatted(dateFormatter))
        session.request("https://europe-west1-logbookbackend.cloudfunctions.net/api/logbook/find/all?sort=-date", method: .get)
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
                    self.isLoading.toggle()
                    break
                }
            }
            .responseDecodable(of: [LogbookModel].self, decoder: decoder) { (response) in
                self.logbooks = response.value ?? []
            }
    }
}
