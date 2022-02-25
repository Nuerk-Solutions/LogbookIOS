//
//  ExportViewModel.swift
//  Logbook
//
//  Created by Thomas on 25.02.22.
//

import Foundation

class ExportViewModel: ObservableObject {
    
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var errorMessage: String?
    @Published var mailData: MailData = MailData.empty
    @Published var downloaded = false
    
    @MainActor
    func downloadXLSX(driver: [DriverEnum], vehicles: [VehicleEnum]) async {
        showAlert = false
        errorMessage = nil
        downloaded = false
        
        let downloadService = DownloadService(urlString: buildUrl(drivers: driver, vehicles: vehicles), fileName: "LogBook_\(Date().formatted(.iso8601))_Language_DE.xlsx")
        isLoading.toggle()
        defer {
            isLoading.toggle()
        }
        
        do {
            let data = try await downloadService.downloadFile()
            //            fileData = data
            let attachmentData = AttachmentData(data: data, mimeType: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", fileName: downloadService.fileName)
            
            mailData = MailData(subject: "Fahrtenbuch", recipients: [""], message: "Hier ist das Fahrtenbuch vom \(Date().formatted(.iso8601))", attachments: [attachmentData])
            //            showMail.toggle()
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

