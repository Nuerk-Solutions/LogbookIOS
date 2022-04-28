//
//  RequestInterceptor.swift
//  Logbook
//
//  Created by Thomas on 13.03.22.
//

import Foundation
import Alamofire

class Interceptor: RequestInterceptor {
    
    let retryLimit = 7
    let retryDelay: TimeInterval = 4
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        urlRequest.cachePolicy = .reloadRevalidatingCacheData
        urlRequest.setValue("Api-Key ca03na188ame03u1d78620de67282882a84", forHTTPHeaderField: "Authorization")
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        if request.retryCount < self.retryLimit {
            if let response = request.task?.response as? HTTPURLResponse, response.statusCode >= 400 {
                consoleManager.print("Retry: \(request.retryCount) with \(response.statusCode)")
                print("Retry: \(request.retryCount) with \(response.statusCode)")
                completion(.retryWithDelay(retryDelay))
            } else {
                consoleManager.print("Statuscode not match!")
                print("Statuscode not match!")
                completion(.doNotRetry)
            }
        } else {
            print("Retry Limit")
            consoleManager.print("Reached retry limit!")
            completion(.doNotRetry)
        }
    }
    
}
