//
//  LogbookListViewModel.swift
//  Logbook
//
//  Created by Thomas on 05.01.22.
//

import Foundation
class LogbookListViewModel: ObservableObject {
    
    @Published var logbooks: [Logbook] = []
    @Published var isLoading = true
    @Published var showAlert = false
    @Published var errorMessage: String?
    
    func fetchLogbooks() {
        self.showAlert = false
        self.errorMessage = nil
        self.isLoading = true
        let apiService = APIService(urlString: "https://api.nuerk-solutions.de/logbook?all=1&sort=-date")
        apiService.getJSON(dateDecodingStrategy: JSONDecoder.DateDecodingStrategy.formatted(.standardT)) { (result: Result<[Logbook], APIError>) in
            defer {
                DispatchQueue.main.async {
                    self.isLoading.toggle()
                }
            }
            switch result {
            case .success(let logbooks):
                DispatchQueue.main.async {
                    print("Success!")
                    self.logbooks = logbooks
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert = true
                    self.errorMessage = error.localizedDescription + "\nPlease contact the developer and provide this error and the steps to reproduce."
                }
            }
        }
    }
    
    func deleteLogbook(queryParamter: String) {
        self.isLoading = true
        let apiService = APIService(urlString: "https://api.nuerk-solutions.de/logbook/")
        apiService.deleteWithQuery(queryParamter: queryParamter) { (result: Result<Bool, APIError>) in
            defer {
                DispatchQueue.main.async {
                    self.isLoading.toggle()
                }
            }
            switch result {
            case .success(let complete):
                DispatchQueue.main.async {
                    print("Success!")
                    print(complete)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert = true
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
