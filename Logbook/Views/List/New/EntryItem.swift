//
//  EntryItem.swift
//  Logbook
//
//  Created by Thomas on 07.06.22.
//

import SwiftUI

struct EntryItem: View {
    
    var entry: LogbookEntry
    
    @EnvironmentObject var model: Model
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        HStack {
            heroImage
            VStack {
                headerElement
                driveReasonElement
//                footerElement
//                    .padding(.bottom, 5)
            }
//            .frame(maxHeight: .infinity, alignment: .topLeading)
        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(.primary.opacity(0.05))
//        .background(.ultraThinMaterial)
//        .clipped()
        .contentShape(RoundedRectangle(cornerRadius: CGFloat(15)))
//        .mask(
//            RoundedRectangle(cornerRadius: 15)
//                .matchedGeometryEffect(id: "mask\(entry.id)", in: namespace)
//        )
    }
    
    
    @ViewBuilder
    var heroImage: some View {
        Image(getVehicleIcon(vehicleTyp: entry.vehicle))
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 110, height: 110)
            .frame(alignment: .leading)
            .padding(-10)
            .background(getVehicleBackgroundColor(vehicleTyp: entry.vehicle))
//            .background(.ultraThinMaterial)
            .clipShape(RoundedCorner(radius: 15))
            .overlay {
                AdditionalInfoImageComponent(logbook: entry)
                    .padding(-15)
            }
    }
    
    @ViewBuilder
    var headerElement: some View {
            HStack {
                Text(entry.vehicle.rawValue)
                    .bold()
                    .font(.system(size: 19))
                HStack(spacing: 1) {
                    Text("@" + entry.driver.rawValue)
                        .truncationMode(.tail)
                        .lineLimit(0)
                    Text("·")
                    Text(DateFormatter.readableDeShort.string(from: entry.date))
                        .lineLimit(0)
                        .minimumScaleFactor(0.5)
                    
                }
                .allowsTightening(true)
                .foregroundStyle(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
    }
    
    @ViewBuilder
    var driveReasonElement: some View {
        HStack {
            Text(entry.reason)
                .lineLimit(3)
                .allowsTightening(true)
                .padding(.trailing, 5)
                .padding(.bottom, 5)
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
    
    @ViewBuilder
    var footerElement: some View {
        HStack(spacing: 0) {
            HStack(spacing: 2) {
                Image(systemName: "road.lanes.curved.left")
                    .resizable()
                    .frame(width: 14, height: 14)
                Text("\(entry.mileAge.difference ?? 0) \(entry.mileAge.unit.name)")
                    .minimumScaleFactor(0.5)
            }
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            HStack(spacing: 2) {
                Image(systemName: "eurosign")
                    .resizable()
                    .frame(width: 14, height: 14)
                Text(String(format: "%.2F", entry.mileAge.cost ?? 0.0))
                
                if (entry.details.covered) {
                    HStack(spacing: 2) {
                        Image(systemName: "checkmark.seal.fill")
                            .resizable()
                            .frame(width: 16, height: 16)
                            .symbolRenderingMode(.multicolor)
                            .symbolEffect(.pulse)
                            .foregroundStyle(.green)
                            .padding(.bottom, 5)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                    .padding(.horizontal, 15)
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        }
        .lineLimit(0)
        .allowsTightening(true)
        .frame(maxWidth: .infinity, alignment: .bottomLeading)
        .foregroundStyle(.gray)
    }
}

struct EntryItem_Previews: PreviewProvider {
    @Namespace static var namespace
    
    static var previews: some View {
        EntryItem(entry: LogbookEntry.previewData.data[0])
            .environmentObject(Model())
            .frame(height: 100)
    }
}
