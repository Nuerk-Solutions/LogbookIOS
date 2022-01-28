//
//  LogbookViewModel.swift
//  Logbook
//
//  Created by Thomas on 16.12.21.
//

import Foundation
import SwiftUI

class LogbookViewModel: ObservableObject {
    
    @Published var latestLogbooks: [Logbook] = []
    @Published var currentLogbook: Logbook = Logbook()
    @Published var isLoading = true
    @Published var showAlert = false
    @Published var errorMessage: String?
    @Published var submitted = false
    
    func fetchLatestLogbooks() {
        self.showAlert = false
        self.isLoading = true
        let apiService = APIService(urlString: "http://192.168.200.184:3000/logbook/find/latest")
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
                    self.latestLogbooks = logbooks
                    self.currentLogbook.currentMileAge = logbooks[1].newMileAge
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert = true
                    self.errorMessage = error.localizedDescription + "\nPlease contact the developer and provide this error and the steps to reproduce."
                }
            }
        }
    }
    
    func submitLogbook(httpBody: Logbook) {
        self.showAlert = false
        self.isLoading = true
        self.submitted = false
        let apiService = APIService(urlString: "http://192.168.200.184:3000/logbook")
        
        let encoder = JSONEncoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        let encodedData = try! encoder.encode(httpBody)
        
        apiService.postJSON(httpBody: encodedData, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy.formatted(.standardT)) { (result: Result<Logbook, APIError>) in
            defer {
                DispatchQueue.main.async {
                    self.isLoading.toggle()
                }
            }
            switch result {
            case .success:
                DispatchQueue.main.async {
                    withAnimation {
                        self.submitted = true
                    }
                    print("Succes!")
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
