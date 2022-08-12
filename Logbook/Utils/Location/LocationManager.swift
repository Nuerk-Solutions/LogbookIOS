//
//  LocationManager.swift
//  Logbook
//
//  Created by Thomas on 19.06.22.
//

import Foundation
import CoreLocation
import SwiftUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private let locationManager: CLLocationManager = CLLocationManager()
    
    @Published var heading: CLHeading?
    @Published var currentLocationCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    @Published var currentLocation: CLLocation = CLLocation()
    
    override init() {
        super.init()
        locationManager.delegate = self
        
        // Init location Updates
//        initUpdates()
    }
    
    private func initUpdates() {
        locationManager.headingFilter = 0
        locationManager.distanceFilter = 0
        
        locationManager.startUpdatingHeading()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
        // Tries to avoid spinning heading arrow
        if newHeading.magneticHeading >= 359 || newHeading.magneticHeading <= 1 {
            self.heading = newHeading
        } else {
            withAnimation(.spring()) {
                self.heading = newHeading
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty {
            self.currentLocationCoordinate = locations.first!.coordinate
            self.currentLocation = locations.first!
        }
    }
    
    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    
}
