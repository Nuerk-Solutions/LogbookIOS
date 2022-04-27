//
//  NetworkManager.swift
//  Logbook
//
//  Created by Thomas on 27.04.22.
//

import Foundation
import Alamofire

enum Result <T, E> {
    
    case success(T)
    case error(E)
}

class NetworkManager: NSObject {
    
    // Create a singleton
    private override init() {
        
    }
    private static let _shared = NetworkManager()
    
    class func shared() -> NetworkManager {
        
        return _shared
    }
    
    private var session = Session()
}

extension NetworkManager {
    
    func executeWith(request: URLRequestConvertible, completion: @escaping (Result<Data?, Error?>) -> Void) {
        
        let interceptor = NetworkInterceptor(retriers: [RetryPolicy(retryLimit: 7)])
        session.request(request, interceptor: interceptor)
            .validate()
            .responseJSON { (response) in
                
                // If response is error
                if let error = response.error as? AFError {
                    guard let data = response.data else {
                        completion(.error(error))
                        return
                    }
                    // Here we need to create an NSError so that we can attach a UserInfo
                    do {
                        // The actual error sent from the server may be available in the Data...so we need to parse out the data.
                        if let userInfo = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            // if the error is empty.. sent back the AFError.
                            if !userInfo.isEmpty {
                                let err = NSError(domain: "Error", code: error.responseCode ?? 888, userInfo: userInfo)
                                completion(.error(err))
                            } else {
                                completion(.error(error))
                            }
                        }
                    } catch (_) {
                        completion(.error(error))
                    }
                } else if let error = response.error {
                    completion(.error(error))
                } else {
                    guard let json = response.data else {
                        let err = NSError(domain: "Unknown", code: -1, userInfo: nil)
                        completion(.error(err))
                        return
                    }
                    completion(.success(json))
                }
        }
    }
}
