//
//  DetailListViewModel.swift
//  Logbook
//
//  Created by Thomas on 05.01.22.
//

import Foundation
import SwiftUI

class DetailViewModel: ObservableObject {
    
    @Published var logbook: LogbookModel?
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var errorMessage: String?
    var logbookId: String?
    
    @MainActor
    func fetchLogbookById() async {
        showAlert = false
        errorMessage = nil
        if let logbookId = logbookId {
            let apiService = APIService(urlString: "https://api2.nuerk-solutions.de/logbook/find/\(logbookId)")
            isLoading.toggle()
            defer { // Defer means that is executed after all is finished
                isLoading.toggle()
            }
            
            do {
                logbook = try await apiService.getJSON()
            } catch {
                showAlert = true
                errorMessage = error.localizedDescription + "\nBitte melde dich bei weiteren Problem bei Thomas."
            }
        }
    }
}
