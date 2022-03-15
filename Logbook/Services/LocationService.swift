//
//  LocationManager.swift
//  Logbook
//
//  Created by Thomas on 05.02.22.
//

import Foundation
import CoreLocation
import CoreMotion
import SwiftUI

class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private let notificationService = NotificationService()
    let locationManager: CLLocationManager = CLLocationManager()
    
    @Published var authorisationStatus: CLAuthorizationStatus = .notDetermined // For always in background question
    @AppStorage("notificationsIconBadge") private var notificationsIconBadge = true
    @AppStorage("allowLocationTracking") private var allowLocationTracking = true
    @AppStorage("notifications") private var showNotifications = true
    
    override init() {
        super.init()
        self.locationManager.delegate = nil
        if !allowLocationTracking {
            return
        }
        if(showNotifications) {
            notificationService.requestNotificationPermission()
        }
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.activityType = .otherNavigation
        locationManager.distanceFilter = 100
        
        let geoFenceRegion: CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(51.03650, 13.68830), radius: 550, identifier: "ARB 19")
        
        locationManager.startMonitoring(for: geoFenceRegion)
        
    }
    
    //    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    //        let mPerS = locationManager.location?.speed
    //        let kmPerH = (mPerS ?? 0) * 3.6
    //        consoleManager.print("m/s: \(mPerS) | km/h:  \(kmPerH)")
    //    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        consoleManager.print("Entered: \(region.identifier)")
        print("Entered: \(region.identifier)")
        consoleManager.print("Notification SEND")
        if showNotifications {
            notificationService.requestLocalNotification(notification: NotificationModel(notificationId: UUID().uuidString, title:"Wilkommen am \(region.identifier) 🏠", body: "Hey du! Es scheint so als ob du wieder zu Hause bist. Hier eine kleine Erinnerung ans Fahrtenbuch 😉", data: nil))
        }
        if notificationsIconBadge {
            notificationService.pushApplicationBadge(amount: 1)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authorisationStatus = status
    }
    
    
    func requestLocationPermission(always: Bool = true) {
        if allowLocationTracking {
            if always {
                self.locationManager.requestAlwaysAuthorization()
            } else {
                self.locationManager.requestWhenInUseAuthorization()
            }
        }
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

extension CMMotionActivity {
    func activityString() -> String {
        // returns a compound string of activities e.g. Stationary Automotive
        var output = ""
        if stationary { output = output + "Stationary "}
        if walking { output = output + "Walking "}
        if running { output = output + "Running "}
        if automotive { output = output + "Automotive "}
        if cycling { output = output + "Cycling "}
        if unknown { output = output + "Unknown "}
        return output
    }
}
