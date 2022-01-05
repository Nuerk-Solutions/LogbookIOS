//
//  DetailListViewModel.swift
//  Logbook
//
//  Created by Thomas on 05.01.22.
//

import Foundation
class DetailListViewModel: ObservableObject {
    
    @Published var logbook: [Logbook] = []
    @Published var isLoading = true
    @Published var showAlert = false
    @Published var errorMessage: String?
    var logbookId: String?
    
    func fetchLogbookById() {
        self.showAlert = false
        self.isLoading = true
        let apiService = APIService(urlString: "https://api.nuerk-solutions.de/logbook/" + logbookId!)
        apiService.getJSON(dateDecodingStrategy: JSONDecoder.DateDecodingStrategy.formatted(.standardT)) { (result: Result<Logbook, APIError>) in
            defer {
                DispatchQueue.main.async {
                    self.isLoading.toggle()
                }
            }
            switch result {
            case .success(let logbook):
                DispatchQueue.main.async {
                    print("Succes!")
                    self.logbook = [logbook]
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert = true
                    self.errorMessage = error.localizedDescription + "\nPlease contact the developer and provide this error and the steps to reproduce."
                }
            }
        }
    }
}
