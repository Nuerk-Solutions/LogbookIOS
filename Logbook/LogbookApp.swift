//
//  LogbookApp.swift
//  Logbook
//
//  Created by Thomas on 26.05.22.
//

import SwiftUI
import SwiftDate

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        SwiftDate.defaultRegion = Region.current
        NetworkActivityIndicatorManager.shared.startDelay = 0
        NetworkActivityIndicatorManager.shared.isEnabled = true
        return true
    }
}




@main
struct LogbookApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var model = Model() // Avoid calling multiple times, ensures that model initilize once and follows the lifecycle of the app
    @StateObject var nR = NetworkReachability()
    @StateObject var nAIM = NetworkActivityIndicatorManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
                .environmentObject(nR)
                .environmentObject(nAIM)
            
        }
    }
}
