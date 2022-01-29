//
//  DetailListViewModel.swift
//  Logbook
//
//  Created by Thomas on 05.01.22.
//

import Foundation
class DetailListViewModel: ObservableObject {
    
    @Published var logbook: Logbook = Logbook()
//    Logbook(driver: .Andrea, vehicle: .init(typ: .Ferrari, currentMileAge: -1, newMileAge: -1), date: Date.now, driveReason: "PLACEHOLDER", additionalInformation: .init(informationTyp: AdditionalInformationEnum.none, information: "", cost: ""))
    @Published var isLoading = true
    @Published var showAlert = false
    @Published var errorMessage: String?
    var logbookId: String?
    
    func fetchLogbookById() {
        self.showAlert = false
        self.isLoading = true
        let apiService = APIService(urlString: "https://api2.nuerk-solutions.de/logbook/find/" + logbookId!)
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
                    print(logbook)
                    self.logbook = logbook
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
