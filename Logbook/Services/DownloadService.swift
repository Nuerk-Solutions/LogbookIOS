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
    
    func downloadFile() async throws -> Data {
        
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
                
                let documentsURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                
                let fileUrl = documentsURL.appendingPathComponent(fileName)
                let fileManager = FileManager()
                
                do {
                    try data.write(to: fileUrl, options: Data.WritingOptions.atomic)
                } catch {
                    continuation.resume(with: .failure(APIError.dataTaskError(error.localizedDescription)))
                }
                
                if (!fileManager.fileExists(atPath: fileUrl.path)) {
                    continuation.resume(with: .failure(APIError.dataTaskError("Downloaded file not found")))
                }
                
                do {
                    let data = try Data(contentsOf: fileUrl)
                    continuation.resume(with: .success(data))
                } catch {
                    print ("error: ", error)
                    continuation.resume(with: .failure(APIError.dataTaskError(error.localizedDescription)))
                }
            }
            .resume()
        }
    }
}
