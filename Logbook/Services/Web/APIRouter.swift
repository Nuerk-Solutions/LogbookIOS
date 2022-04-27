//
//  APIRouter.swift
//  Logbook
//
//  Created by Thomas on 27.04.22.
//

import Foundation
import Alamofire

enum HTTPHeaderFields: String {
    case authentication = "Authorization"
    case contentType     = "Content-Type"
    case acceptType      = "Accept"
    case acceptEncoding  = "Accept-Encoding"
    case requestName     = "RequestName"
}

enum ContentType: String {
    case json = "application/json"
}

enum RequestNames: String{
    case fetchLatestLogbook
    case fetchLogbookById
    case submitLogook
    case updateLogbook
    case fetchInvoiceHistory
    case fetchDriverStats
    case fetchVehicleStats
    case createInvoice
    case fetchRefuelStations
}

public enum APIRouter: URLRequestConvertible {
    
    static let baseURL = "https://europe-west1-logbookbackend.cloudfunctions.net/api/logbook"
    
    // authentiacte user
    case fetchLatestLogbook(Void)
    case fetchLogbookById(String)

    // The http method to be used
    var method: HTTPMethod {
        switch self {
        case .fetchLatestLogbook:
            return .post
        case .fetchLogbookById:
            return .get
        }
    }
    // path of the request
    var path: String {
        switch self {
        case .fetchLatestLogbook:
            return "/find/latest"
        case .fetchLogbookById(let id):
            return "/find/\(id)"
        }
    }
    
    var authheader: String {
        
//        switch self {
            return "Api-Key ca03na188ame03u1d78620de67282882a84"
//        case .fetchLatestLogbook:
//            return ""
//        case .fetchLogbookById(let token):
//            return "Bearer \(token)"
//        }
    }
    var requestName: String {
        
        switch self {
        case .fetchLatestLogbook:
            return RequestNames.fetchLatestLogbook.rawValue
        case .fetchLogbookById:
            return RequestNames.fetchLogbookById.rawValue
        }
    }
    
    var encoding: ParameterEncoding {
        
        switch self {
        case .fetchLatestLogbook:
            return JSONEncoding.default
        case .fetchLogbookById:
            return URLEncoding.default
        }
    }
        
    public func asURLRequest() throws -> URLRequest {
        let param: [String: Any]? = {
            switch self {
            case .fetchLatestLogbook:
                return nil
            case .fetchLogbookById:
                return nil
            }
        }()
        let url = try APIRouter.baseURL.asURL()
        let finalPath = path
        var request = URLRequest(url: url.appendingPathComponent(finalPath))
        request.httpMethod = method.rawValue
        request.timeoutInterval = TimeInterval(10 * 1000)
        
        // Get the header data
        request.addValue(getAuthorizationHeader(), forHTTPHeaderField: HTTPHeaderFields.authentication.rawValue)
        request.addValue(getRequestNameHeader(), forHTTPHeaderField: HTTPHeaderFields.requestName.rawValue)

        return try encoding.encode(request, with: param)
    }
    
    private func getAuthorizationHeader() -> String {
        let header = authheader
        return header
    }
    
    private func getRequestNameHeader() -> String {
        let header = requestName
        return header
    }
}
