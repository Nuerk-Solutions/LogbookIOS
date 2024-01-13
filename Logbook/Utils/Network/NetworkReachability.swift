//
//  NetworkReachability.swift
//  Logbook
//
//  Created by Thomas on 28.05.22.
//

import Foundation
import SystemConfiguration
import Network
import Alamofire

class NetworkReachability : ObservableObject {
    
    static let shared = NetworkReachability()
    @Published private(set) var reachable: Bool = true
//    private let reachability = SCNetworkReachabilityCreateWithName(nil, "www.nuerk-solutions2332.de")
    
    // Monitor network connection
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "Monitor")
    @Published private(set) var connected: Bool = true
    
    init() {
//        self.reachable = checkConnection()
        startConnectionMonitor()
        startNetworkReachabilityObserver()
    }
    
    let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "http://127.0.0.1:3000")

    func startNetworkReachabilityObserver() {
        reachabilityManager?.startListening(onUpdatePerforming: { [weak self] status in
            switch status {
            case .reachable(.ethernetOrWiFi), .reachable(.cellular):
//                self?.reachable = true
                print(status)
            default:
                print(status)
//                self?.reachable = false
                }
        })
       }
    
    
    func startConnectionMonitor() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.connected = path.status == .satisfied
            }
        }
        
        monitor.start(queue: queue)
    }
//    
//    private func isNetworkReachable(with flags: SCNetworkReachabilityFlags) -> Bool {
//        let isReachable = flags.contains(.reachable)
//        let connectionRequired = flags.contains(.connectionRequired)
//        let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
//        let canConnectWithoutIntervention = canConnectAutomatically && !flags.contains(.interventionRequired)
//        
//        return isReachable && canConnectWithoutIntervention
//    }
//    
//    func checkConnection() -> Bool {
//        var flags = SCNetworkReachabilityFlags()
//        SCNetworkReachabilityGetFlags(reachability!, &flags)
//
//        return isNetworkReachable(with: flags)
//    }
}
