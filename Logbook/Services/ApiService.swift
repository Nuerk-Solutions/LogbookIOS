//
//  ApiService.swift
//  Logbook
//
//  Created by Thomas on 16.12.21.
//

import Foundation

struct APIService {
    
    let urlString: String
    
    func getJSON<T: Decodable>(dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .formatted(.standardT),
                               keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) async throws -> T {
        guard
            let url = URL(string: urlString)
        else {
            throw APIError.invalidURL
        }
        return try await withCheckedThrowingContinuation { continuation in
            URLSession.shared.dataTask(with: url) { data, response, error in
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
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = dateDecodingStrategy
                decoder.keyDecodingStrategy = keyDecodingStrategy
                do {
                    let decodedData = try decoder.decode(T.self, from: data)
                    continuation.resume(with: .success(decodedData))
                } catch DecodingError.dataCorrupted(let context) {
                    print(context)
                    continuation.resume(with: .failure(APIError.decodingError(context.debugDescription)))
                } catch DecodingError.keyNotFound(let key, let context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                    continuation.resume(with: .failure(APIError.decodingError(context.debugDescription)))
                } catch DecodingError.valueNotFound(let value, let context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                    continuation.resume(with: .failure(APIError.decodingError(context.debugDescription)))
                } catch DecodingError.typeMismatch(let type, let context) {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                    continuation.resume(with: .failure(APIError.decodingError(context.debugDescription)))
                } catch {
                    print("error: ", error)
                    continuation.resume(with: .failure(APIError.decodingError(error.localizedDescription)))
                }
                
            }
            .resume()
        }
    }
    
    func postJSON<T: Encodable>(_ value: T,
                                dateEncodingStrategy: JSONEncoder.DateEncodingStrategy = .formatted(.standardT),
                                keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy = .useDefaultKeys) async throws -> Bool {
        guard
            let url = URL(string: urlString)
        else {
            throw APIError.invalidURL
        }
        
        // Prepare request
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        
        // Encode Data to JSON
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = dateEncodingStrategy
        encoder.keyEncodingStrategy = keyEncodingStrategy
        
        do {
            request.httpBody = try encoder.encode(value)
        } catch {
            throw APIError.encodingError(error.localizedDescription)
        }
        
        
        return try await withCheckedThrowingContinuation{ continuation in
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard
                    let httpResponse = response as? HTTPURLResponse,
                    httpResponse.statusCode == 201
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
                continuation.resume(with: .success(true))
            }
            .resume()
        }
    }
}

enum APIError: Error, LocalizedError {
    case invalidURL
    case invalidResponseStatus
    case dataTaskError(String)
    case corruptData
    case decodingError(String)
    case encodingError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("The endpoint URL is invalid", comment: "")
        case .invalidResponseStatus:
            return NSLocalizedString("The APIO failed to issue a valid response.", comment: "")
        case .dataTaskError(let string):
            return string
        case .corruptData:
            return NSLocalizedString("The data provided appears to be corrupt", comment: "")
        case .decodingError(let string):
            return string
        case .encodingError(let string):
            return string
        }
    }
}
