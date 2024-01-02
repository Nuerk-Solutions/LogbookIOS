//
//  LogbookAPI.swift
//  Logbook
//
//  Created by Thomas on 01.06.22.
//

import Foundation
import SwiftUI_Extensions
import Alamofire

struct LogbookAPI {
    
    static let shared = LogbookAPI()
    private init() {}
    
//    private let baseUrl = "https://api.nuerk-solutions.de/logbook"
    private let baseUrl = "http://127.0.0.1:3000/logbook"
    private let session = ApiSession.logbookShared.session
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.iso8601Full)
        return decoder
    }()
    
    private let jsonEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(.iso8601Full)
        return encoder
    }()
    
    func fetch(with requestParameters: LogbookRequestParameters) async throws -> LogbookAPIResponse {
        try await fetchLogbooks(from: generateSearchUrl(with: requestParameters))
    }
    
    func fetchLast() async throws -> LogbookAPIResponse {
        try await fetchLogbooks(from: URL(string: baseUrl + "/find/latest")!)
    }
    
    func send(with logbook: LogbookEntry) async throws -> LogbookEntry {
        try await sendLogbook(from: URL(string: baseUrl)!, logbook: logbook)
    }
    
    func delete(with logbook: LogbookEntry) {
        deleteLogbook(from: URL(string: baseUrl + "/\(logbook._id!)")!)
    }
    
    private func fetchLogbooks(from url: URL) async throws -> LogbookAPIResponse {
        print(url)
//        print(LogbookEntry.previewData)
        do {
            return try await session.request(url, method: .get)
                .validate(statusCode: 200..<201)
                .validate(contentType: ["application/json"])
                .responseData { (response) in
                    switch response.result {
                    case .success:
                        break
                    case .failure(let error):
                        return
//                        print(error)
                        // see https://karenxpn.medium.com/swiftui-mvvm-combine-alamofire-make-http-requests-the-right-way-and-handle-errors-258e0f0bb0df
                        //                    return generateError(code: response.response?.statusCode ?? -1, description: error.localizedDescription ?? "Ein Fehler ist aufgetreten")
                    }
//                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
//                        print("Data: \(utf8Text)")
//                    }
                }
                .serializingDecodable(LogbookAPIResponse.self, decoder: jsonDecoder)
                .value
            
        } catch DecodingError.keyNotFound(let key, let context) {
            print("could not find key \(key) in JSON: \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            print("could not find type \(type) in JSON: \(context.debugDescription)")
        } catch DecodingError.typeMismatch(let type, let context) {
            print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(let context) {
            print("data found to be corrupted in JSON: \(context.debugDescription)")
        } 
        catch let error as NSError {
            NSLog("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
        }
        return LogbookAPIResponse(total: 0, length: 0, limit: 0, pageCount: 0, page: 0, data: [])
    }
    
    private func sendLogbook(from url: URL, logbook body: LogbookEntry) async throws -> LogbookEntry {
        return try await session.request(url, method: .post, parameters: body, encoder: JSONParameterEncoder(encoder: jsonEncoder))
            .validate(statusCode: 201..<202)
            .validate(contentType: ["application/json"])
            .responseData { (response) in
                switch response.result {
                case .success:
                    break
                case .failure(let error):
                    print(error)
                }
            }
            .serializingDecodable(LogbookEntry.self, decoder: jsonDecoder)
            .value
    }
    
    private func deleteLogbook(from url: URL) {
        session.request(url, method: .delete)
            .validate(statusCode: 204..<205)
            .responseData { (response) in
                switch response.result {
                case .success:
                    break
                case .failure(let error):
                    print(error)
                    break
                }
            }
    }
    
    private func generateError(code: Int = 1, description: String) async -> Error {
        NSError(domain: "LogbookAPI", code: code, userInfo: [NSLocalizedDescriptionKey: description])
    }
    
    private func generateSearchUrl(with requestParameters: LogbookRequestParameters) -> URL {
//        var queryItems = [URLQueryItem(name: "sort", value: requestParameters.sort)]
        var queryItems: [URLQueryItem] = []
        if requestParameters.page != nil && requestParameters.limit != nil {
            queryItems.append(URLQueryItem(name: "page", value: String(requestParameters.page!)))
            queryItems.append(URLQueryItem(name: "limit", value: String(requestParameters.limit!)))
        }
        if requestParameters.startDate != nil {
            queryItems.append(URLQueryItem(name: "startDate", value: requestParameters.startDate!))
        }
        var components = URLComponents(string: baseUrl)
        // Need to be set here beacuse override it
        components?.path = "/logbook/find/all"
        components?.queryItems = queryItems
        return components!.url!
    }
}

struct LogbookRequestParameters {
    
//    var sort: String = "-date"
    var page: Int?
    var limit: Int?
    var startDate: String? = "2018-01-01"
}
