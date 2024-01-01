//
//  GasStationViewModel.swift
//  Logbook
//
//  Created by Thomas on 19.06.22.
//

import Foundation
import CoreLocation
import SwiftLocation
import SwiftUI
import Alamofire

@MainActor
class GasStationViewModel: ObservableObject {
    
    // MARK: - Location Stuff
    @Published var currentHeading: CLHeading?
    @Published var currentLocation: CLLocation = CLLocation(latitude: 0, longitude: 0)
    
    @Published var headingRequests: [GPSHeadingRequest] = []
    @Published var locationRequests: [GPSLocationRequest] = []
    
    // MARK: - Actual data fetching
    @Published var phase = DataFetchPhase<[GasStationEntry]>.empty
    private let gasStationAPI = GasStationAPI.shared
    private var isPreviewData = false
    
    // MARK: - Data caching
    private let cache = InMemoryCache<[GasStationEntry]>(expirationInterval: 60)
    
    // MARK: - Data Matrix Decsion
    @Published var factorMap = [Double: Double]()
    @Published var ratingMap = [Int : Double]()
    
    @AppStorage("gasStationRadius") var gasStationRadius: Int = 5
    @AppStorage("selectedGasStationVehicle") var stationForVehicle: VehicleEnum = .Ferrari
    @AppStorage("gasStationSort") var gasStationSort: SortTyp = .Preis
    @AppStorage("isGasStationSortDirectionAsc") var isGasStationSortDirectionAsc: Bool = true
    @AppStorage("isIntelligentGasStationRadius") var isIntelligentGasStationRadius = false
    
    init(gasStations: [GasStationEntry]? = nil) {
        if let gasStations = gasStations {
            calculationEvaluation(data: gasStations) // Includes Success phase setter
            isPreviewData.toggle()
        } else {
            self.phase = .empty
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            startHeadingUpdates()
            startLocationUpdates()
        }
    }
    
    func calculationEvaluation(data gasStations: [GasStationEntry]) {
        //        factorMap.removeAll()
        //        ratingMap.removeAll()
        
        let dictonary = Dictionary(grouping: gasStations, by: {$0.preis})
        let sortedKeys = dictonary.keys.sorted()
//        let sortedArrFromDict = dictonary.sorted(by: {$0.key < $1.key}).flatMap({$0.value.sorted(by: {$0.distance < $1.distance})})
        
        
        
        stride(from: sortedKeys.first ?? 0, to: (sortedKeys.last ?? 0) + 0.001, by: 0.001).enumerated().forEach { index, item in
            factorMap.updateValue(pow(2, Double(index)) / 10 + 1, forKey: item.truncate(places: 4))
        }
        
        gasStations.forEach { item in
            let rating = (factorMap[item.preis] ?? 0.0) + item.distance / 10
            ratingMap[item.poiID] = rating
        }
        
        if gasStationSort == .Preis && isGasStationSortDirectionAsc {
            let sortedDictonary = dictonary.sorted(by: {$0.key < $1.key}).flatMap({$0.value.sorted(by: {$0.distance < $1.distance})})

            withAnimation {
                phase = .success(sortedDictonary)
            }
        } else {
            withAnimation {
                phase = .success(gasStations)
            }
        }
    }
    
//
//    private func getCoords() async throws -> (Double, Double) {
//        try await withCheckedThrowingContinuation { continuation in
//            SwiftLocation.gpsLocationWith {
//                $0.subscription = .single
//                $0.accuracy = .house
//                $0.activityType = .automotiveNavigation
//                $0.timeout = .immediate(1)
//            }.then { result in
//                switch result {
//                case .success(let newData):
//                    continuation.resume(returning: (newData.coordinate.latitude, newData.coordinate.longitude))
//                case .failure(let error):
//                    print(error.localizedDescription)
//                    continuation.resume(throwing: error)
//                }
//            }
//        }
//    }
    
    private func waitUntil() async {
        if currentLocation.coordinate.latitude == 0.0 {
            do {
                try await Task.sleep(nanoseconds: 1_000_000_000)
                await waitUntil()
            } catch {
                print(error)
            }
        }
    }
    
    func loadGasStations() async {
        if Task.isCancelled || isPreviewData {
            isPreviewData.toggle()
            return
        }
        
        if let gasStations = await cache.value(forKey: stationForVehicle.fuelTyp.rawValue) {
            print("[GasStation]: CACHE HIT for \(stationForVehicle.fuelTyp.rawValue)")
            withAnimation {
                //                phase = .success(gasStations)
                calculationEvaluation(data: gasStations)
            }
            return
        }
        
        withAnimation {
            phase = .empty
        }
        
        var radius = currentLocation.speed * 3.6 >= 70 ? 30 : 5
        if !isIntelligentGasStationRadius {
            radius = gasStationRadius
        }
        do {
            await waitUntil()
            
            
            gasStationAPI.cancelPreviousRequest()
            
            let gasStations = try await gasStationAPI.fetch(with: GasStationRequestParameters(lat: currentLocation.coordinate.latitude, lng: currentLocation.coordinate.longitude, fuelTyp: stationForVehicle.fuelTyp, radius: radius, sortTyp: gasStationSort, sortDirection: isGasStationSortDirectionAsc ? "asc" : "desc"))
            await cache.setValue(gasStations, forKey: stationForVehicle.fuelTyp.rawValue)
            
            if Task.isCancelled { return }
            
            print("[GasStation]: Fetched GasStations for fuel: \(stationForVehicle.fuelTyp), radius: \(radius)km, sortTyp: \(gasStationSort)")
            print("[GasStation]: \(gasStations.count)")
            calculationEvaluation(data: gasStations) // Includes success phase setter
            
        } catch {
            print(error)
            if Task.isCancelled { return }
            
            withAnimation {
                phase = .failure(error)
            }
        }
    }
    
    private func startHeadingUpdates() {
        let request = SwiftLocation.gpsHeadingWith {
            $0.subscription = .continous
        }
        request.then { result in
            switch result {
            case .success(let newData):
                self.currentHeading = newData
            case .failure(let error):
                print("ERROR: \(error)")
            }
        }
        headingRequests.append(request)
    }
    
    private func startLocationUpdates() {
        let request = SwiftLocation.gpsLocationWith {
            $0.subscription = .continous
            $0.accuracy = .house
            $0.minTimeInterval = 5
            $0.activityType = .automotiveNavigation
        }
        request.then { result in
            switch result {
            case .success(let newData):
                self.currentLocation = newData
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
        locationRequests.append(request)
    }
    
    func stopAllLocationUpdates() {
        headingRequests.forEach { request in
            request.cancelAllSubscriptions()
            request.cancelRequest()
        }
        
        locationRequests.forEach { request in
            request.cancelAllSubscriptions()
            request.cancelRequest()
        }
    }
    
}
extension Double {
    func truncate(places : Int)-> Double {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
}
