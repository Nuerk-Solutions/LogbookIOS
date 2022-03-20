//
//  HelpViewModel.swift
//  Logbook
//
//  Created by Thomas on 19.02.22.
//

import Foundation
import SwiftUI

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
        
        
        if(!locationService.hasPermission()) {
            self.showAlert = true
            self.errorMessage = "Bitte gib den Standort frei"
           return
        }
        locationService.locationManager.startUpdatingLocation()
        consoleManager.print("Init Location Updates")
        let lat = locationService.locationManager.location?.coordinate.latitude
        consoleManager.print("Lat: \(lat!)")
        let long = locationService.locationManager.location?.coordinate.longitude
        consoleManager.print("Long: \(long!)")
        var speed = locationService.locationManager.location?.speed
        consoleManager.print("Speed: \(speed!)")
        guard let speed = speed else { return speed = 0 }
        let radius = speed >= 25.0 ? 25 : 5
        consoleManager.print("Calculated Radius: \(radius)")
        // 100 km/h = 27.7 m/s
        
        
        let urlString = "https://creativecommons.tankerkoenig.de/json/list.php?lat=\(lat!)&lng=\(long!)&rad=\(radius)&type=\(fuelType)&sort=price&apikey=\(API_KEY)"
        
        print(urlString)
        
        let apiService = APIService(urlString: urlString)
        
        withAnimation {
            
            isLoading.toggle()
        }
        
        defer { // Defer means that is executed after all is finished
            withAnimation {
                isLoading.toggle()
            }
        }
        
        do {
            patrolStations = try await apiService.getJSON()
            print("Patrol Station Amount: \(patrolStations.stations.count)")
            consoleManager.print("Patrol Station Amount: \(patrolStations.stations.count)")
            print(patrolStations)
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                locationService.locationManager.stopUpdatingLocation()
                consoleManager.print("Stopped updating location in Refuel Model")
            }
            
        } catch {
            showAlert = true
            errorMessage = error.localizedDescription + "\nBitte melde dich bei weiteren Problem bei Thomas."
        }
    }
}
