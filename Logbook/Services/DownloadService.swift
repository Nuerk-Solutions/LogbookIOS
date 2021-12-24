//
//  DownloadService.swift
//  Logbook
//
//  Created by Thomas on 18.12.21.
//

import Foundation

struct DownloadService {
//    let urlString: String
//    let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//
//    func downloadFile<T: Decodable>(completion: @escaping (Result<T,APIError>) -> Void) {
//        guard
//            let url = URL(string: urlString)
//        else {
//            completion(.failure(.invalidURL))
//            return
//        }
//        URLSession.shared.downloadTask(with: url) { localUrl, response, error in
//            guard
//                let httpResponse = response as? HTTPURLResponse,
//                httpResponse.statusCode == 200
//            else {
//                completion(.failure(.invalidResponseStatus))
//                return
//            }
//            guard
//                error == nil
//            else {
//                completion(.failure(.dataTaskError(error!.localizedDescription)))
//                return
//            }
//            guard
//                let localUrl = localUrl
//            else {
//                completion(.failure(.corruptData))
//                return
//            }
//            do {
//
//                if let string = try? Data(contentsOf: localUrl) {
//                    print(string)
//                    //completion(.success(string))
//                    // See https://kavsoft.dev/SwiftUI_2.0/Download_Task
//                }
//            } catch {
//                completion(.failure(.decodingError(error.localizedDescription)))
//            }
//
//        }
//        .resume()
//    }
}

func getDocumentsDirectory() -> URL {
    // find all possible documents directories for this user
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    // just send back the first one, which ought to be the only one
    return paths[0]
}
