//
//  LocationManager.swift
//  Logbook
//
//  Created by Thomas on 05.02.22.
//

import Foundation
import CoreLocation
import SwiftUI

class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private let notificationService = NotificationService()
    let locationManager: CLLocationManager = CLLocationManager()
    
    @Published var authorizationStatus: CLAuthorizationStatus // For always in background question
    @Published var lastSeenLocation: CLLocation?
    @Published var currentPlacemark: CLPlacemark?
    
    
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
        
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            locationManager.startMonitoring(for: geoFenceRegion)
        }
        
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
