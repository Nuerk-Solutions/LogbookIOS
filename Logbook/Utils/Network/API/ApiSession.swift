//
//  ApiSession.swift
//  Logbook
//
//  Created by Thomas on 01.06.22.
//

import Foundation
import Alamofire

class ApiSession {
    
    static let gasStationShared = ApiSession(requestAdapter: GasStationSessionAdapter())
    
    let session: Session
    
    init(requestAdapter: RequestAdapter) {
        let interceptor = Interceptor(adapter: requestAdapter, retrier: RetryPolicy(retryLimit: 5, retryableHTTPStatusCodes: Set(202...400)))
        session = Session(interceptor: interceptor)
        session.sessionConfiguration.timeoutIntervalForRequest = 15
    }
    
}

class GasStationSessionAdapter: RequestAdapter {
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        urlRequest.headers.add(name: "Ocp-Apim-Subscription-Key", value: "e9216740d3b64ae0bdaf6cff961afc1b")
        completion(.success(urlRequest))
    }
}
