//
//  NetworkReachability.swift
//  Logbook
//
//  Created by Thomas on 28.05.22.
//

import Foundation
import SystemConfiguration
import Network

class NetworkReachability : ObservableObject {
    
    @Published private(set) var reachable: Bool = true
    private let reachability = SCNetworkReachabilityCreateWithName(nil, "www.google.de")
    
    // Monitor network connection
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "Monitor")
    @Published private(set) var connected: Bool = true
    
    init() {
        self.reachable = checkConnection()
        startConnectionMonitor()
    }
    
    func startConnectionMonitor() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.connected = path.status == .satisfied
            }
        }
        
        monitor.start(queue: queue)
    }
    
    private func isNetworkReachable(with flags: SCNetworkReachabilityFlags) -> Bool {
        let isReachable = flags.contains(.reachable)
        let connectionRequired = flags.contains(.connectionRequired)
        let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        let canConnectWithoutIntervention = canConnectAutomatically && !flags.contains(.interventionRequired)
        
        return isReachable && (!connectionRequired || canConnectWithoutIntervention)
    }
    
    func checkConnection() -> Bool {
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(reachability!, &flags)
        
        return isNetworkReachable(with: flags)
    }
}
