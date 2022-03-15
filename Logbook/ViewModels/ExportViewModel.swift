//
//  ExportViewModel.swift
//  Logbook
//
//  Created by Thomas on 25.02.22.
//

import Foundation
import SwiftUI
import Alamofire

class ExportViewModel: ObservableObject {
    
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var errorMessage: String?
    @Published var downloaded = false
    @Published var showActivity = false
    @Published var progress: Double = 0.0
    @Published var fileName: String?
    @Environment(\.presentationMode) var presentationMode
    
    @AppStorage("openActivityViewAfterExport") private var openActivityViewAfterExport = false
    
    
    let session: Session
    let interceptor: RequestInterceptor = Interceptor()
    
    
    init() {
        session = Session(interceptor: interceptor)
    }
    
    @MainActor
    func downloadXLSX(drivers: [DriverEnum], vehicles: [VehicleEnum]) async {
        showAlert = false
        errorMessage = nil
        downloaded = false
        isLoading.toggle()
        
        let currentDate = Date().formatted(.iso8601).replacingOccurrences(of: ":", with: "_")
        let fileName = "LogBook_\(currentDate)_Language_DE.xlsx".replacingOccurrences(of: ":", with: "_")
        print(currentDate)
        //        let downloadService = DownloadService(urlString: buildUrl(drivers: driver, vehicles: vehicles), fileName: "LogBook_\(currentDate)_Language_DE.xlsx".replacingOccurrences(of: ":", with: "_"))
        //        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        let destination: DownloadRequest.Destination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(fileName)
            
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        let url = buildUrl(drivers: drivers, vehicles: vehicles)
        print(url)
        session.download(url, to: destination)
            .downloadProgress { progress in
                self.progress = progress.fractionCompleted
                print("Download Progress: \(progress.fractionCompleted)")
            }
            .responseData { response in
                switch response.result {
                case.failure(let error):
                    switch response.response?.statusCode {
                    default:
                        self.errorMessage = error.localizedDescription
                        self.showAlert = true
                        self.isLoading = false
                        print("error fetch all", error)
                        break
                    }
                    print(error)
                case.success(let data):
                    print("Sucess Fetch All:", data)
                    self.fileName = fileName
//                    print(response.fileURL?.path)
                    self.isLoading.toggle()
                        if self.openActivityViewAfterExport {
                            self.showActivity.toggle()
                        } else {
                            guard
                                let url = URL(string: response.fileURL!.absoluteString.replacingOccurrences(of: "file://", with: "shareddocuments://"))
                            else {
                                return
                            }
                            if UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url) { completion in
                                    if completion {
                                        self.presentationMode.wrappedValue.dismiss()
                                    }
                                }
                            }
                    }
                    self.downloaded.toggle()
                    break
                }
                //        defer {
                //            isLoading.toggle()
                //        }
                
                //        do {
                //            _ = try await downloadService.downloadFile()
                //            fileName = downloadService.fileName
                //            downloaded.toggle()
                //        } catch  {
                //            errorMessage = error.localizedDescription + "\nBitte melde dich bei weiteren Problem bei Thomas."
                //            self.showAlert = true
                //        }
            }
    }
    
    func buildUrl(drivers: [DriverEnum], vehicles: [VehicleEnum]) -> String {
        let baseUrl = "https://europe-west1-logbookbackend.cloudfunctions.net/api/logbook/download?"
        
        var builedUrl = baseUrl
        
        builedUrl.append("drivers=")
        for driver in drivers {
            if driver == drivers.last {
                builedUrl.append("\(driver.id)")
            } else {
                builedUrl.append("\(driver.id),")
            }
        }
        builedUrl.append("&vehicles=")
        
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
