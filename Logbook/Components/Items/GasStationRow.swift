//
//  GasStationRow.swift
//  Logbook
//
//  Created by Thomas on 22.06.22.
//

import SwiftUI
import CoreLocation
import SwiftDate

struct GasStationRow: View {
    
    var currentLocation: CLLocation?
    var heading: CLHeading?
    
    var station: GasStationEntry
    
    var circleValue: Double = 1
    var progressValue: Double = 1
    
    private let completeHoursMinutesSeconds: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter
    }()
    
    private let timerFormatter: RelativeDateTimeFormatter = {
        var formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter
    }()
    
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            HeadingIndicator(currentLocation: currentLocation?.coordinate, currentHeading: heading, targetLocation: CLLocationCoordinate2D(latitude: station.lat, longitude: station.lon)) {
            Image(systemName: "arrow.up")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 24, height: 24)
                .frame(width: 45, height: 45)
        }
            .mask(Circle())
            .padding(6)
            .background(Color(UIColor.systemBackground).opacity(0.3))
            .mask(Circle())
            .padding(6)
            .overlay(CircularView(value: 1 - circleValue))
            
            VStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(station.name)
                        .font(.callout.weight(.medium))
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)
                    
                    
                    
                    let distance = (currentLocation?.distance(from: CLLocation(latitude: station.lat, longitude: station.lon)))! / 1000
                    
                    let distanceString = String(format: "(%.2f km)", locale: Locale(identifier: "de"), distance)
                    
                    
//                            Text("\(station.strasse) (\(distance, specifier: "%.2f") km)")
                    Text("\(station.strasse) \(distanceString)")
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.secondary)
                    

                }
                
                HStack {
                    PriceView(price: station.preis)
                    let timeSortDate = station.timeSort.toDate("HH:mm:ss")
                    let mergedDate = station.datum.dateBySet(hour: timeSortDate?.hour, min: timeSortDate?.minute, secs: timeSortDate?.second)?.date
                    let timeString = mergedDate!.toRelative(since: DateInRegion(), dateTimeStyle: .named, unitsStyle: .short)
                    
                    Text("\(timeString)")
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.secondary)
                        .offset(y: 1)
                }
                
                
                if progressValue != 0 {
                    ProgressView(value: progressValue)
                        .accentColor(.white)
                        .frame(maxWidth: 132)
                }
            }
            Spacer()
        
        
//                SectionIconRow(iconName: "arrow.up", circleValue: 1 - circleValue, progressValue: progressValue) {
//                    Text(station.brand)
//                        .font(.caption.weight(.medium))
//                        .foregroundStyle(.secondary)
//
//                    PriceView(price: station.price ?? 0.000)
//
//
//                    Text("\(station.street) \(station.houseNumber) (\(station.dist, specifier: "%.2f") km)")
//                        .font(.caption.weight(.medium))
//                        .foregroundStyle(.secondary)
        }
        .accessibilityElement(children: .combine)
    }
}

struct GasStationRow_Previews: PreviewProvider {
    static var previews: some View {
        GasStationRow(currentLocation: homeCoordinates, heading: CLHeading(), station: GasStationWelcome.previewData.data.tankstellen.first!)
    }
}
