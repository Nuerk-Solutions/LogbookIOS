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
        let baseUrl = "https://api2.nuerk-solutions.de/logbook/download?"
        
        var builedUrl = baseUrl
        
        for driver in drivers {
            if driver == drivers.first {
                builedUrl.append("driver[]=\(driver.id)")
            } else {
                builedUrl.append("&driver[]=\(driver.id)")
            }
        }
        
        for vehicle in vehicles {
            builedUrl.append("&vehicleTyp[]=\(vehicle.id)")
        }
        return builedUrl
        
    }
}

