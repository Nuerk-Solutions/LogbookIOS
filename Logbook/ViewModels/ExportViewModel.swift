//
//  ExportViewModel.swift
//  Logbook
//
//  Created by Thomas on 25.02.22.
//

import Foundation
import SwiftUI

class ExportViewModel: ObservableObject {
    
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var errorMessage: String?
    @Published var downloaded = false
    @Published var fileName: String?
    
    @MainActor
    func downloadXLSX(driver: [DriverEnum], vehicles: [VehicleEnum]) async {
        showAlert = false
        errorMessage = nil
        downloaded = false
        
        let currentDate = Date().formatted(.iso8601).replacingOccurrences(of: ":", with: "_")
        print(currentDate)
        let downloadService = DownloadService(urlString: buildUrl(drivers: driver, vehicles: vehicles), fileName: "LogBook_\(currentDate)_Language_DE.xlsx".replacingOccurrences(of: ":", with: "_"))
        isLoading.toggle()
        defer {
            isLoading.toggle()
        }
        
        do {
            _ = try await downloadService.downloadFile()
            fileName = downloadService.fileName
            downloaded.toggle()
        } catch  {
            errorMessage = error.localizedDescription + "\nBitte melde dich bei weiteren Problem bei Thomas."
            self.showAlert = true
        }
    }
    
    func buildUrl(drivers: [DriverEnum], vehicles: [VehicleEnum]) -> String {
        let baseUrl = "https://europe-west1-logbookbackend.cloudfunctions.net/api/logbook/download?"
        
        var builedUrl = baseUrl
        
        builedUrl.append("driver=")
        for driver in drivers {
            if driver == drivers.last {
                builedUrl.append("\(driver.id)")
            } else {
                builedUrl.append("\(driver.id),")
            }
            builedUrl.append(",")
        }
        builedUrl.append("&vehicle=")
        
        for vehicle in vehicles {
            if vehicle == vehicles.last {
                builedUrl.append("\(vehicle.id)")
            } else {
                builedUrl.append("\(vehicle.id),")
            }
        }
        return builedUrl
        
    }
}

