//
//  HelpViewModel.swift
//  Logbook
//
//  Created by Thomas on 19.02.22.
//

import Foundation
import SwiftUI

class HelpViewModel: ObservableObject {
    
    @Published var patrolStations: PatrolStationModel = PatrolStationModel(ok: false, license: "", data: "", status: "", stations: [])
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var errorMessage: String?
    
    private let API_KEY = "58b93125-c092-3fa4-b455-31a197c645ba"
    
    @MainActor
    func fetchFuelPrice(fuelType: String, locationService: LocationService) async {
        showAlert = false
        errorMessage = nil
        locationService.locationManager.startUpdatingLocation()
            let long = locationService.locationManager.location?.coordinate.longitude
            let lat = locationService.locationManager.location?.coordinate.latitude
            var speed = locationService.locationManager.location?.speed
            guard let speed = speed else { return speed = 0 }
            let radius = speed >= 25.0 ? 25 : 3.5
            // 100 km/h = 27.7 m/s
            
        let apiService = APIService(urlString: "https://creativecommons.tankerkoenig.de/json/list.php?lat=\(lat!)&lng=\(long!)&rad=\(radius)&type=\(fuelType)&sort=price&apikey=\(API_KEY)")
            isLoading.toggle()
            defer { // Defer means that is executed after all is finished
                isLoading.toggle()
            }
            
            do {
                patrolStations = try await apiService.getJSON()
                
            } catch {
                showAlert = true
                errorMessage = error.localizedDescription + "\nBitte melde dich bei weiteren Problem bei Thomas."
            }
    }
}
