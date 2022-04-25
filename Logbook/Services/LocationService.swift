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
    let locationManager: CLLocationManager
    
    @Published var authorizationStatus: CLAuthorizationStatus // For always in background question
    @Published var lastSeenLocation: CLLocation?
    @Published var currentPlacemark: CLPlacemark?
    
    
    @Preference(\.allowLocationTracking) var allowLocationTracking
    @Preference(\.notifications) var notifications
    @Preference(\.notificationsIconBadge) var notificationsIconBadge
    
    override init() {
        locationManager = CLLocationManager()
        authorizationStatus = locationManager.authorizationStatus
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        
        let geoFenceRegion: CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(51.03650, 13.68830), radius: 550, identifier: "ARB 19")
        
        locationManager.startMonitoring(for: geoFenceRegion)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    }
    
    func fetchCountryAndCity(for location: CLLocation?) {
        guard let location = location else { return }
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            self.currentPlacemark = placemarks?.first
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        consoleManager.print("Entered: \(region.identifier)")
        print("Entered: \(region.identifier)")
        consoleManager.print("Notification SEND")
        if notifications {
            notificationService.requestLocalNotification(notification: NotificationModel(notificationId: UUID().uuidString, title:"Wilkommen am \(region.identifier) 🏠", body: "Hey du! Es scheint so als ob du wieder zu Hause bist. Hier eine kleine Erinnerung ans Fahrtenbuch 😉", data: nil))
        }
        if notificationsIconBadge {
            notificationService.pushApplicationBadge(amount: 1)
        }
    }
    
    // TODO: Check wich method works
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authorizationStatus = status
        print(status)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.authorizationStatus = manager.authorizationStatus
        print(manager.authorizationStatus)
    }
    
//    func requestLocationPermission() {
//        self.locationManager.requestAlwaysAuthorization()
//    }
    
    
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
