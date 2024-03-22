//
//  GasStationAPI.swift
//  Logbook
//
//  Created by Thomas on 12.07.22.
//

import Foundation
import SwiftUI_Extensions

struct GasStationAPI {
    
    //https://apim-p-gw02.adac.de/spritpreise/liste/51.03650/13.68830?Sorte=Diesel&UmkreisKm=5&PageSize=20&PageNumber=1&SortiereNach=Preis&SortierRichtung=asc
    
    static let shared = GasStationAPI()
    private init() {}
    
    private let session = ApiSession.gasStationShared.session
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.readableDeShort)
        return decoder
    }()
    
    func fetch(with requestParameters: GasStationRequestParameters) async throws -> [GasStationEntry] {
        try await fetchGasStations(from: generateURL(with: requestParameters)).data.tankstellen
    }
    
    func cancelPreviousRequest() {
        session.cancelAllRequests()
    }
    
    private func fetchGasStations(from url: URL) async throws -> GasStationWelcome {
        return try await session.request(url, method: .get)
            .validate(statusCode: 200..<201)
            .validate(contentType: ["application/json"])
            .responseData { (response) in
                switch response.result {
                case .success:
                    break
                case .failure(let error):
                    print(error)
                    // see https://karenxpn.medium.com/swiftui-mvvm-combine-alamofire-make-http-requests-the-right-way-and-handle-errors-258e0f0bb0df
                    //                    return generateError(code: response.response?.statusCode, description: error.localizedDescription ?? "Ein Fehler ist aufgetreten")
                }
            }
            .serializingDecodable(GasStationWelcome.self, decoder: jsonDecoder)
            .value
    }
    
    private func generateURL(with requestParameters: GasStationRequestParameters) -> URL {
        let queryItems = [
            URLQueryItem(name: "Sorte", value: requestParameters.fuelTyp),
            URLQueryItem(name: "UmkreisKm", value: String(requestParameters.radius)),
            URLQueryItem(name: "PageSize", value: String(requestParameters.pageSize)),
            URLQueryItem(name: "PageNumber", value: String(requestParameters.pageNumber)),
            URLQueryItem(name: "SortiereNach", value: String(requestParameters.sortTyp.rawValue)),
            URLQueryItem(name: "SortierRichtung", value: String(requestParameters.sortDirection))
        ]
        
        
        var components = URLComponents(string: "https://apim-p-gw02.adac.de")
        components?.path = "/spritpreise/liste/\(requestParameters.lat.description)/\(requestParameters.lng.description)"
        components?.queryItems = queryItems
        print(components?.url!)
        return components!.url!
    }
}
