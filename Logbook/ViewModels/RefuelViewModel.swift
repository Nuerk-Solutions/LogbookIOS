//
//  HelpViewModel.swift
//  Logbook
//
//  Created by Thomas on 19.02.22.
//

import Foundation
import SwiftUI
import CoreLocation

class RefuelViewModel: ObservableObject {
    
    @Published var patrolStations: PatrolStationModel = PatrolStationModel(stations: [])
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var errorMessage: String?
    
    private let API_KEY = "58b93125-c092-3fa4-b455-31a197c645ba"
    
    @MainActor
    func fetchFuelPrice(fuelType: String, locationService: LocationService) async {
        showAlert = false
        errorMessage = nil
        
        withAnimation {
            isLoading.toggle()
        }
        
        defer { // Defer means that is executed after all is finished
            withAnimation {
                isLoading.toggle()
            }
        }
        
        if !Reachability.isConnectedToNetwork() {
            return
        }
        
        if(!locationService.hasPermission()) {
            self.showAlert = true
            self.errorMessage = "Bitte gib den Standort frei"
           return
        }
        consoleManager.print("Calculate radius...")
        let lat = locationService.locationManager.location?.coordinate.latitude
        let long = locationService.locationManager.location?.coordinate.longitude
        var speed = locationService.locationManager.location?.speed
        consoleManager.print("Speed: \(speed!)")
        guard let speed = speed else { return speed = 0 }
        let radius = speed >= 25.0 ? 25 : 5
        consoleManager.print("Calculated Radius: \(radius)")
        // 100 km/h = 27.7 m/s
        
        
        let urlString = "https://creativecommons.tankerkoenig.de/json/list.php?lat=\(lat!)&lng=\(long!)&rad=\(radius)&type=\(fuelType)&sort=price&apikey=\(API_KEY)"
        let apiService = APIService(urlString: urlString)
        
        
        do {
            patrolStations = try await apiService.getJSON()
            
            patrolStations.stations.indices.forEach { index in
                patrolStations.stations[index].bearing = getBearingBetweenTwoPoints(start: CLLocation(latitude: lat!, longitude: long!), end: CLLocation(latitude: patrolStations.stations[index].lat, longitude: patrolStations.stations[index].lng))
            }
            
            patrolStations.stations = patrolStations.stations.filter { $0.isOpen && $0.price != nil}
            
            print("Patrol Station Amount: \(patrolStations.stations.count)")
            consoleManager.print("Patrol Station Amount: \(patrolStations.stations.count)")
        } catch {
            showAlert = true
            errorMessage = error.localizedDescription + "\nBitte melde dich bei weiteren Problem bei Thomas."
            printError(description: "Refuel fetch error", errorMessage: errorMessage?.debugDescription)
        }
    }
    
    func degreesToRadians(degrees: Double) -> Double { return degrees * .pi / 180.0 }
    func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / .pi }

    func getBearingBetweenTwoPoints(start : CLLocation, end : CLLocation) -> Double {

        let latRadiansStart = degreesToRadians(degrees: start.coordinate.latitude)
        let latRadiansEnd = degreesToRadians(degrees: end.coordinate.latitude)

        let lonRadiansStart = degreesToRadians(degrees: start.coordinate.longitude)
        let lonRadiansEnd = degreesToRadians(degrees: end.coordinate.longitude)

        let dLon = lonRadiansEnd - lonRadiansStart

        let y = sin(dLon) * cos(latRadiansEnd)
        let x = cos(latRadiansStart) * sin(latRadiansEnd) - sin(latRadiansStart) * cos(latRadiansEnd) * cos(dLon)
        var radiansBearing = atan2(y, x)
//        radiansBearing = radiansBearing < 0 ? radiansBearing + (2 * .pi) : radiansBearing

        return radiansToDegrees(radians: radiansBearing)
    }
}
