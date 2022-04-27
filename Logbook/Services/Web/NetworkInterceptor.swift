//
//  NetworkInterceptor.swift
//  Logbook
//
//  Created by Thomas on 27.04.22.
//

import Foundation
import Alamofire

class NetworkInterceptor: Interceptor {
    
//    private var newToken = "" // fetch from the storage
//    private let authManager = AuthManager()
//    override func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (AFResult<URLRequest>) -> Void) {
        // If there is no request name in the fields, then just continue execution without adapting.
//        guard let headerFields = urlRequest.allHTTPHeaderFields, let reqName = headerFields[HTTPHeaderFields.requestName.rawValue] else {
//            completion(.success(urlRequest))
//            return
//        }
//        // If request name is authenticate a user then we need to append the new token and try this.
//        if reqName == RequestNames.fetchData.rawValue {
//            var adaptedRequest = urlRequest
//            adaptedRequest.setValue("Bearer \(newToken)", forHTTPHeaderField: HTTPHeaderFields.authentication.rawValue)
//            completion(.success(adaptedRequest))
//        } else {
//            completion(.success(urlRequest))
//        }
//    }
    
    override func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
            // If still error after 3 retries, then we show error to the user
            if (request.retryCount < 3) {
//                print("retry the failed request with new token")
//                authManager.authenticateUserWith {[weak self] (result) in
//                    switch result {
//                    case .success(let token):
//                        //save it to storage
//                        self?.newToken = token
//                        completion(.retry)
//                    case .error:
//                        completion(.retry)
//                        break
//                    }
                }
            } else {
                completion(.doNotRetry)
            }
        } else {
            completion(.doNotRetry)
        }
    }
}
