//
//  LocationManager.swift
//  Logbook
//
//  Created by Thomas on 05.02.22.
//

import Foundation
import CoreLocation
import CoreMotion

class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private let notificationService = NotificationService()
    let locationManager: CLLocationManager = CLLocationManager()
    let motionActivityManager = CMMotionActivityManager()
    
    @Published var isAutomotive: Bool = false
    @Published var activities = [CMMotionActivity] ()
    @Published var authorisationStatus: CLAuthorizationStatus = .notDetermined // For always in background question
    
    override init() {
        super.init()
        notificationService.requestNotificationPermission()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 500
        let geoFenceRegion: CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(51.03650, 13.68830), radius: 500, identifier: "ARB 19")
        
        //        if CMMotionActivityManager.isActivityAvailable() {
        print("AN")
        motionActivityManager.startActivityUpdates(to: OperationQueue.main) { [self] motion in
            guard let newMotion = motion else { return }
            print(newMotion.activityString())
            consoleManager.print(newMotion.activityString())
            if(motion?.automotive == true) {
                self.isAutomotive = true
            }
        }
        locationManager.startMonitoring(for: geoFenceRegion)
        
    }
    
    //    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    //        for currentLocation in locations {
    //            print("\(String(describing: index)): \(currentLocation)")
    //        }
    //    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        consoleManager.print("Entered: \(region.identifier)")
        print("Entered: \(region.identifier)")
        if(isAutomotive) {
            consoleManager.print("Notification SEND")
            notificationService.requestLocalNotification(notification: NotificationModel(notificationId: UUID().uuidString, title:"Wilkommen am \(region.identifier) 🏠", body: "Hey du! Es scheint so als ob du wieder zu Hause bist. Hier eine kleine Erinnerung ans Fahrtenbuch 😉", data: nil))
            notificationService.pushApplicationBadge(amount: 1)
            self.isAutomotive.toggle()
        }
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
