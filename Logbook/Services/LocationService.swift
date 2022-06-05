//
//  LocationManager.swift
//  Logbook
//
//  Created by Thomas on 05.02.22.
//

import Foundation
import CoreLocation
import SwiftUI
import Combine

class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private let notificationService = NotificationService()
    let locationManager: CLLocationManager = CLLocationManager()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var authorizationStatus: CLAuthorizationStatus // For always in background question
    @Published var lastSeenLocation: CLLocation?
    @Published var currentPlacemark: CLPlacemark?
    @Published var heading: Double = 0
    
    
    @Preference(\.allowLocationTracking) var allowLocationTracking
    @Preference(\.notifications) var notifications
    @Preference(\.notificationsIconBadge) var notificationsIconBadge
    
    
    override init() {
        //        locationManager = CLLocationManager()
        authorizationStatus = locationManager.authorizationStatus
        super.init()
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        
        let geoFenceRegion: CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(51.03650, 13.68830), radius: 600, identifier: "ARB 19")
        geoFenceRegion.notifyOnExit = false
        geoFenceRegion.notifyOnEntry = true
        
        locationManager.stopMonitoring(for: geoFenceRegion)
        
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            locationManager.startMonitoring(for: geoFenceRegion)
        }
        
        locationManager.startUpdatingHeading()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.heading = newHeading.trueHeading
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        consoleManager.print("Entered: \(region.identifier)")
        
        print("Entered: \(region.identifier)")
        if notifications {
            notificationService.requestLocalNotification(notification: NotificationModel(notificationId: UUID().uuidString, title:"Wilkommen am \(region.identifier) 🏠", body: "Hey du! Es scheint so als ob du wieder zu Hause bist. Hier eine kleine Erinnerung ans Fahrtenbuch 😉", data: nil), removePendingRequest: true)
        }
        if notificationsIconBadge {
            notificationService.increaseApplicationBadge(incresment: 1)
        }
        consoleManager.print("Notification SEND")
    }
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.authorizationStatus = manager.authorizationStatus
        print(manager.authorizationStatus)
    }
    
    func hasPermission() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch locationManager.authorizationStatus {
            case .notDetermined, .restricted, .denied :
                return false
                
            case .authorizedWhenInUse, .authorizedAlways:
                return true
                
            default:
                return false
            }
        }
        return false
    }
}


//class Model: ObservableObject, Identifiable {
//    @Published var offset: CGFloat = 0
//
//    let id = UUID()
//    private var timer: Timer!
//    
//    init() {
//        var runner: (() -> ())?
//        runner = {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
//                if let self = self {
//                    self.update()
//                    runner?()
//                }
//            }
//        }
//        runner?()
//    }
//    func update() {
//        offset = CGFloat.random(in: 0...300)
//    }
//}
//
//struct TestView: View {
//    @ObservedObject var model1 = Model()
//    @ObservedObject var model2 = Model()
//    @ObservedObject var model3 = Model()
//    @ObservedObject var model4 = Model()
//
//    var body: some View {
//        List {
//            ForEach([model1, model2, model3, model4]) {
//                Rectangle()
//                    .foregroundColor(.red)
//                    .frame(width: $0.offset, height: 30, alignment: .center)
//                    .animation(.default)
//            }
//        }
//    }
//}
