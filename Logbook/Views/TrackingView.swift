//
//  TrackingView.swift
//  Logbook
//
//  Created by Thomas on 16.03.22.
//

import SwiftUI
import CoreLocation

struct TrackingView: View {
    
    @EnvironmentObject private var locationService: LocationService
    
    var body: some View {
        VStack {
            VStack {
                PairView(
                    leftText: "Latitude:",
                    rightText: String(coordinate?.latitude ?? 0)
                )
                PairView(
                    leftText: "Longitude:",
                    rightText: String(coordinate?.longitude ?? 0)
                )
                PairView(
                    leftText: "Altitude",
                    rightText: String(locationService.lastSeenLocation?.altitude ?? 0)
                )
                PairView(
                    leftText: "Speed",
                    rightText: String(locationService.lastSeenLocation?.speed ?? 0)
                )
                PairView(
                    leftText: "Country",
                    rightText: locationService.currentPlacemark?.country ?? ""
                )
                PairView(leftText: "City", rightText: locationService.currentPlacemark?.administrativeArea ?? ""
                )
            }
            .padding()
        }.onAppear {
//            if !locationService.hasPermission() {
//                locationService.requestLocationPermission()
//            }
            locationService.locationManager.startUpdatingLocation()
        }
        .onDisappear {
            locationService.locationManager.stopUpdatingLocation()
        }
    }
    
    var coordinate: CLLocationCoordinate2D? {
        locationService.lastSeenLocation?.coordinate
    }
}


struct PairView: View {
    let leftText: String
    let rightText: String
    
    var body: some View {
        HStack {
            Text(leftText)
            Spacer()
            Text(rightText)
        }
    }
}

struct TrackingView_Previews: PreviewProvider {
    static var previews: some View {
        TrackingView()
    }
}
