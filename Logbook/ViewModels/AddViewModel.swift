//
//  LogbookViewModel.swift
//  Logbook
//
//  Created by Thomas on 16.12.21.
//

import Foundation
import SwiftUI

class AddViewModel: ObservableObject {
    
    @Published var latestLogbooks: [LogbookModel]?
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var errorMessage: String?
    @Published var submitted = false
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return dateFormatter
    }()
    
    @MainActor
    func fetchLatestLogbooks() async {
        showAlert = false
        errorMessage = nil
        let apiService = APIService(urlString: "https://api2.nuerk-solutions.de/logbook/find/latest")
        isLoading.toggle()
        
        defer {
            withAnimation {
                isLoading.toggle()
            }
        }
        
        do {
            latestLogbooks = try await apiService.getJSON()
        } catch {
            showAlert = true
            errorMessage = error.localizedDescription + "\nBitte melde dich bei weiteren Problem bei Thomas."
        }
    }
    
    @MainActor
    func submitLogbook(logbook: LogbookModel) async {
        self.submitted = false
        let apiService = APIService(urlString: "https://api2.nuerk-solutions.de/logbook")
        
        isLoading.toggle()
        
        defer {
            withAnimation {
                isLoading.toggle()
            }
        }
        
        do {
            submitted = try await apiService.postJSON(logbook, dateEncodingStrategy: .formatted(dateFormatter))
        } catch {
            showAlert = true
            errorMessage = error.localizedDescription + "\nBitte melde dich bei weiteren Problem bei Thomas."
        }
    }
}
