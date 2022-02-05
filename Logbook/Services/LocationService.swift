//
//  LocationManager.swift
//  Logbook
//
//  Created by Thomas on 05.02.22.
//

import Foundation
import CoreLocation

class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private let notificationService = NotificationService()
    let locationManager: CLLocationManager = CLLocationManager()
    @Published var authorisationStatus: CLAuthorizationStatus = .notDetermined // For always in background question
    
    override init() {
        super.init()
        notificationService.requestNotificationPermission()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 100
        let geoFenceRegion: CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(51.03650, 13.68830), radius: 100, identifier: "ARB 19")
        
        locationManager.startMonitoring(for: geoFenceRegion)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for currentLocation in locations {
            print("\(index): \(currentLocation)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Entered: \(region.identifier)")
        notificationService.requestLocalNotification(notification: NotificationModel(notificationId: UUID().uuidString, title:"Wilkommen am \(region.identifier) 👋🏻", body: "Hey du! Es scheint so als ob du wieder zu Hause bist. Hier eine kleiner erinnerung ans Fahrtenbuch 😉", data: nil))
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exited: \(region.identifier)")
        notificationService.requestLocalNotification(notification: NotificationModel(notificationId: UUID().uuidString, title: "Tschüss \(region.identifier)", body: "Hey du! Bitte denke ans Fahrtenbuch wenn du angekommen bist 😉", data: nil))
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authorisationStatus = status
    }
    
    
    func requestLocationPermission(always: Bool = true) {
        if always {
            self.locationManager.requestAlwaysAuthorization()
        } else {
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
}
