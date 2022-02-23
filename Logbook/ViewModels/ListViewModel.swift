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
    @Published var mailData: MailData = MailData.empty
    
    
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
            isLoading.toggle()
        }
        do {
            logbooks = try await apiService.getJSON(dateDecodingStrategy: .formatted(dateFormatter))
        } catch {
            showAlert = true
            errorMessage = error.localizedDescription + "\nBitte melde dich bei weiteren Problem bei Thomas."
        }
    }
    
    @MainActor
    func downloadXLSX() async {
        showAlert = false
        errorMessage = nil
        let downloadService = DownloadService(urlString: "https://api2.nuerk-solutions.de/logbook/download", fileName: "LogBook_\(Date().formatted(.iso8601))_Language_DE.xlsx")
        isLoading.toggle()
        print("1-1")
        defer {
            isLoading.toggle()
        }
        
        print("1-2")
        do {
            
            print("1-3")
            try await downloadService.downloadFile()
            
            
            print("1-4")
            let attachmentData = AttachmentData(data: getXLSXData(fileName: downloadService.fileName)!, mimeType: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", fileName: downloadService.fileName)
            
            print("1-5")
            mailData = MailData(subject: "Fahrtenbuch", recipients: [""], message: "Hier ist das Fahrtenbuch vom \(Date().formatted(.iso8601))", attachments: [attachmentData])
        } catch  {
            self.errorMessage = "\(error)"
            self.showAlert = true
        }
    }
    
    private func getDocumentsDirectory() -> URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    func getXLSXData(fileName: String) -> Data? {
        let docDirectory = getDocumentsDirectory()
        let filePath = docDirectory!.appendingPathComponent(fileName)
        
//        guard let fileData = NSData(contentsOf: filePath) else {
//            print("NO DATA")
//            return nil
        print(filePath)
        
        do {
            return try Data(contentsOf: filePath)
        } catch {
            print("\(error)")
        }
        
//        }
        return nil
    }
}
