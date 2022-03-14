//
//  RequestInterceptor.swift
//  Logbook
//
//  Created by Thomas on 13.03.22.
//

import Foundation
import Alamofire

class Interceptor: RequestInterceptor {
    
    let retryLimit = 6
    let retryDelay: TimeInterval = 4
    var isRetrying = false
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        urlRequest.setValue("Api-Key ca03na188ame03u1d78620de67282882a84", forHTTPHeaderField: "Authorization")
        print("Apdt Call")
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        let response = request.task?.response as? HTTPURLResponse
        print(response?.statusCode)
        if request.retryCount < self.retryLimit {
            if let statusCode = response?.statusCode, statusCode >= 400, !isRetrying {
                print("Pre Retry")
                self.isRetrying = true
                self.determineError(error: error, completion: completion)
                return
            }
            else {
                print("Retry with Delay Fallback")
                completion(.retryWithDelay(self.retryDelay))
                return
            }
        } else {
            print("Cancel all")
            AF.session.getAllTasks { (tasks) in
                tasks.forEach {
                    $0.cancel()
                }
            }
            completion(.doNotRetry)
            print("Retry Limit")
            return
        }
        print("Success")
        completion(.doNotRetry)
        return
    }
    
    private func determineError(error: Error, completion: @escaping (RetryResult) -> Void) {
        if let afError = error as? AFError {
            switch afError {
            case .responseValidationFailed(let reason):
                self.determineResponseValidationFailed(reason: reason, completion: completion)
                break
            default:
                self.isRetrying = false
                completion(.retryWithDelay(self.retryDelay))
                break
            }
        }
    }
    
    private func determineResponseValidationFailed(reason: AFError.ResponseValidationFailureReason, completion: @escaping (RetryResult) -> Void) {
        switch reason {
        case .unacceptableStatusCode(let code):
//            switch code {
//            case 400:
//                self.isRetrying = false
//                completion(.retryWithDelay(self.retryDelay))
//                print("Retry 400")
//            case 401:
//                self.isRetrying = false
//                completion(.retryWithDelay(self.retryDelay))
//                print("Retry 401")
//
//            case 404:
//                    self.isRetrying = false
//                    completion(.retryWithDelay(self.retryDelay))
//                    print("Retry 404")
//            default: // AuthenticationAction.logout.rawValue
                print("Statuscode", code)
//            print(reason)
            
                self.isRetrying = false
                completion(.retryWithDelay(self.retryDelay))
            break
//                AF.session.getAllTasks { (tasks) in
//                    tasks.forEach {$0.cancel() }
//                }
                // Redirect to the login page
//                completion(.doNotRetry)
//            }
        default:
            self.isRetrying = false
            print("Finished")
            completion(.doNotRetry)
//            completion(.retryWithDelay(self.retryDelay))
        }
    }
    
}
