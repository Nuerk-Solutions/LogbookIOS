//
//  LogbookViewModel.swift
//  Logbook
//
//  Created by Thomas on 16.12.21.
//

import Foundation

class LogbookViewModel: ObservableObject {
    
    @Published var latestLogbooks: [Logbook] = []
    @Published var currentLogbook: Logbook = Logbook(driver: .Andrea, vehicle: Vehicle(typ: .Ferrari, currentMileAge: 0, newMileAge: 0), date: Date(), driveReason: "Stadtfahrt", additionalInformation: AdditionalInformation(informationTyp: AdditionalInformationEnum.none, information: "", cost: ""))
    @Published var isLoading = true
    @Published var showAlert = false
    @Published var errorMessage: String?
    
    func fetchLatestLogbooks() {
        self.showAlert = false
        self.isLoading = true
        let apiService = APIService(urlString: "https://api.nuerk-solutions.de/logbook")
        apiService.getJSON(dateDecodingStrategy: JSONDecoder.DateDecodingStrategy.formatted(.standardT)) { (result: Result<[Logbook], APIError>) in
            defer {
                DispatchQueue.main.async {
                    self.isLoading.toggle()
                }
            }
            switch result {
            case .success(let logbooks):
                DispatchQueue.main.async {
                    print("Succes!")
                    self.latestLogbooks = logbooks
                    self.currentLogbook.vehicle = Vehicle(typ: .Ferrari, currentMileAge: logbooks[1].vehicle.newMileAge, newMileAge: logbooks[1].vehicle.newMileAge)
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
        let apiService = APIService(urlString: "https://api.nuerk-solutions.de/logbook")
        
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
            case .success(let logbooks):
                DispatchQueue.main.async {
                    print("Succes!")
                    print(logbooks)
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
