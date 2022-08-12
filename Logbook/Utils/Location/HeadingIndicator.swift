//
//  HeadingIndicator.swift
//  Logbook
//
//  Created by Thomas on 19.06.22.
//

import CoreLocation
import SwiftUI

public struct HeadingIndicator<Content: View>: View {
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

extension Array where Element: UIColor {
    func intermediate(percentage: CGFloat) -> UIColor {
        let percentage = Swift.max(Swift.min(percentage, 100), 0) / 100
        switch percentage {
        case 0: return first ?? .clear
        case 1: return last ?? .clear
        default:
            let approxIndex = percentage / (1 / CGFloat(count - 1))
            let firstIndex = Int(approxIndex.rounded(.down))
            let secondIndex = Int(approxIndex.rounded(.up))
            let fallbackIndex = Int(approxIndex.rounded())

            let firstColor = self[firstIndex]
            let secondColor = self[secondIndex]
            let fallbackColor = self[fallbackIndex]

            var (r1, g1, b1, a1): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
            var (r2, g2, b2, a2): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
            guard firstColor.getRed(&r1, green: &g1, blue: &b1, alpha: &a1) else { return fallbackColor }
            guard secondColor.getRed(&r2, green: &g2, blue: &b2, alpha: &a2) else { return fallbackColor }

            let intermediatePercentage = approxIndex - CGFloat(firstIndex)
            return UIColor(red: CGFloat(r1 + (r2 - r1) * intermediatePercentage),
                           green: CGFloat(g1 + (g2 - g1) * intermediatePercentage),
                           blue: CGFloat(b1 + (b2 - b1) * intermediatePercentage),
                           alpha: CGFloat(a1 + (a2 - a1) * intermediatePercentage))
        }
    }
}

internal extension Double {
    var radians: Double {
        Measurement(value: self, unit: UnitAngle.degrees)
            .converted(to: .radians)
            .value
    }

    var degrees: Double {
        Measurement(value: self, unit: UnitAngle.radians)
            .converted(to: .degrees)
            .value
    }
}
