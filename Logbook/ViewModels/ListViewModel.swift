//
//  LogbookListViewModel.swift
//  Logbook
//
//  Created by Thomas on 05.01.22.
//

import Foundation
import SwiftUI
class ListViewModel: ObservableObject {
    
    @Published var logbooks: [LogbookModel] = []
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var errorMessage: String?
    
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return dateFormatter
    }()
    
    @MainActor
    func fetchLogbooks() async {
        showAlert = false
        errorMessage = nil
        let apiService = APIService(urlString: "https://api2.nuerk-solutions.de/logbook/find/all?sort=-date")
        isLoading.toggle()
        defer {
            withAnimation {
                isLoading.toggle()
            }
        }
        do {
            logbooks = try await apiService.getJSON(dateDecodingStrategy: .formatted(dateFormatter))
        } catch {
            showAlert = true
            errorMessage = error.localizedDescription + "\nBitte melde dich bei weiteren Problem bei Thomas."
        }
    }
    
}
