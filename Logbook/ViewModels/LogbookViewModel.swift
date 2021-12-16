//
//  LogbookViewModel.swift
//  Logbook
//
//  Created by Thomas on 16.12.21.
//

import Foundation

class LogbookViewModel: ObservableObject {
    @Published var latestLogbooks: [Logbook] = []
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var errorMessage: String?
    
    func fetchLatestLogbooks() {
        let apiService = APIService(urlString: "https://api.nuerk-solutions.de/logbook")
        isLoading.toggle()
        apiService.getJSON(dateDecodingStrategy: JSONDecoder.DateDecodingStrategy.formatted(.standardT)) { (result: Result<[Logbook], APIError>) in
            defer {
                DispatchQueue.main.async {
                    self.isLoading.toggle()
                }
            }
            switch result {
            case .success(let logbooks):
                DispatchQueue.main.async {
                    self.latestLogbooks = logbooks
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

// Placed extension here, because it only refers to this specify class
//extension LogbookViewModel {
//    convenience init(forPreview: Bool = false) {
//        self.init()
//        if forPreview {
//            self.posts = Post.mockSingleUsersPostArray
//        }
//    }
//}
