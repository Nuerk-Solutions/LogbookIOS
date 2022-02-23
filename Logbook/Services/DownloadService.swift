//
//  DownloadService.swift
//  Logbook
//
//  Created by Thomas on 23.02.22.
//

import Foundation

struct DownloadService {
    
    let urlString: String
    let fileName: String
    let fileManager: FileManager = FileManager()
    
    func downloadFile() async throws {
        
        guard
            let url = URL(string: urlString)
        else {
            throw APIError.invalidURL
        }
        
        // Prepare request
        var request = URLRequest(url: url)
        if(urlString.contains("nuerk-solutions.de")) {
            request.setValue("Api-Key ca03na188ame03u1d78620de67282882a84", forHTTPHeaderField: "Authorization")
        }
        
        
        return try await withCheckedThrowingContinuation{ continuation in
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard
                    let httpResponse = response as? HTTPURLResponse,
                    httpResponse.statusCode == 200
                else {
                    continuation.resume(with: .failure(APIError.invalidResponseStatus))
                    return
                }
                guard
                    error == nil
                else {
                    continuation.resume(with: .failure(APIError.dataTaskError(error!.localizedDescription)))
                    return
                }
                guard
                    let data = data
                else {
                    continuation.resume(with: .failure(APIError.corruptData))
                    return
                }
                
                print("2")
                do {
                    print("3")
                    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                    
                    print("4")
                    let savedURL = documentsURL?.appendingPathComponent(fileName)
                    print(savedURL)
                    
                    print("5")
//                    try FileManager.default.moveItem(at: data, to: savedURL!)
                    if (fileManager.fileExists(atPath: savedURL!.path)) {
//                        continuation.resume(with: .success(true))
                        print("SAVED")
                        print(savedURL?.path)
                    }
                    print("6")
                    try data.write(to: savedURL!, options: Data.WritingOptions.atomic)
                        continuation.resume(with: .success(()))
                } catch {
                    print ("file error: \(error)")
                }
            }
            .resume()
        }
    }
}
