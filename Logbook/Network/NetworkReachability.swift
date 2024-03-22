//
//  NetworkReachability.swift
//  Logbook
//
//  Created by Thomas on 28.05.22.
//

import Foundation
import Alamofire
import SwiftUI

class NetworkReachability : ObservableObject {
    
    static let shared = NetworkReachability()
    @Published private(set) var reachable: Bool = true
    let reachabilityManager = NetworkReachabilityManager(host: "www.apple.com")

     init() {
        startListening()
    }

    func startListening() {
        reachabilityManager?.startListening { status in
            switch status {
            case .notReachable:
                withAnimation {
                    self.reachable = false
                }
            case .reachable(.ethernetOrWiFi), .reachable(.cellular):
                withAnimation {
                    self.reachable = true
                }
            case .unknown:
                    self.reachable = false
                print("Internet availability is unknown.")
            }
        }
    }
}
