//
//  HeadingIndicator.swift
//  Logbook
//
//  Created by Thomas on 19.06.22.
//

import CoreLocation
import SwiftUI

public struct HeadingIndicatorContainer<Content: View>: View {
    let currentLocation: CLLocationCoordinate2D?
    let currentHeading: CLHeading?
    let targetLocation: CLLocationCoordinate2D
    let content: Content

    var targetBearing: Double {
        let deltaL = targetLocation.longitude.radians - (currentLocation?.longitude.radians ?? 0)
        let thetaB = targetLocation.latitude.radians
        let thetaA = currentLocation?.latitude.radians ?? 0

        let x = cos(thetaB) * sin(deltaL)
        let y = cos(thetaA) * sin(thetaB) - sin(thetaA) * cos(thetaB) * cos(deltaL)
        let bearing = atan2(x, y)

        return bearing.degrees
    }

    var targetHeading: Double {
        targetBearing - (currentHeading?.magneticHeading ?? 0)
    }
    
    var targetDifference: Int {
        Int(targetHeading + 180 + 360) % 360 - 180
    }

    public init(currentLocation: CLLocationCoordinate2D?,
                currentHeading: CLHeading?,
                targetLocation: CLLocationCoordinate2D,
                content: Content)
    {
        self.currentLocation = currentLocation
        self.currentHeading = currentHeading
        self.targetLocation = targetLocation
        self.content = content
    }

    public init(currentLocation: CLLocationCoordinate2D?,
                currentHeading: CLHeading?,
                targetLocation: CLLocationCoordinate2D,
                contentBuilder: () -> Content)
    {
        self.currentLocation = currentLocation
        self.currentHeading = currentHeading
        self.targetLocation = targetLocation
        self.content = contentBuilder()
    }

    public var body: some View {
        content
            .rotationEffect(.degrees(self.targetHeading))
            .foregroundColor(Color([.green, .green, .orange, .orange, .red].intermediate(percentage: CGFloat(abs(targetDifference)))))
    }
}
