//
//  NetworkReachability.swift
//  Logbook
//
//  Created by Thomas on 28.05.22.
//

import Foundation
import Alamofire

class NetworkReachability : ObservableObject {
    
    static let shared = NetworkReachability()
    @Published private(set) var reachable: Bool = true
    let reachabilityManager = NetworkReachabilityManager(host: "www.apple.com")

    private init() {
        startListening()
    }

    func startListening() {
        reachabilityManager?.startListening { status in
            switch status {
            case .notReachable:
                self.reachable = false
            case .reachable(.ethernetOrWiFi), .reachable(.cellular):
                self.reachable = true
            case .unknown:
                self.reachable = false
                print("Internet availability is unknown.")
            }
        }
    }
}
