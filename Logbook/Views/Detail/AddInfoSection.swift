//
//  AddInfoSection.swift
//  Logbook
//
//  Created by Thomas Nürk on 01.01.24.
//

import SwiftUI

struct AddInfoSection: View {
    
    var entry: LogbookEntry
    
    var body: some View {
        Group {
            if(entry.service != nil) {
                SectionIconRow(iconName: "wrench.and.screwdriver", circleValue: 1, progressValue: 0) {
                    Text("Informationstyp")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.secondary)
                    Text("Wartung")
                        .fontWeight(.semibold)
                }
                .padding(20)
                .background(.ultraThinMaterial)
                .backgroundStyle(cornerRadius: 30)
                .padding(20)
                .padding(.top, -60)
                //            .padding(.top, verticalSizeClass == .compact ? 0 : 80)
                
                SectionIconRow(iconName: "doc.text", circleValue: 1, progressValue: 0) {
                    Text("Beschreibung")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.secondary)
                    Text("\(entry.service?.message ?? "")")
                        .fontWeight(.semibold)
                }
                .padding(20)
                .background(.ultraThinMaterial)
                .backgroundStyle(cornerRadius: 30)
                .padding(20)
                .padding(.top, -40)
                //            .padding(.top, verticalSizeClass == .compact ? 0 : 80)
                
                SectionImageRow(imageName: "eurosign", circleValue: 1, progressValue: 0) {
                    Text("Kosten")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.secondary)
                    Text(entry.service?.price.formatted(.currency(code: "EUR")) ?? "-1")
                        .fontWeight(.semibold)
                }
                .padding(20)
                .background(.ultraThinMaterial)
                .backgroundStyle(cornerRadius: 30)
                .padding(20)
                .padding(.top, -40)
            } else if(entry.refuel != nil) {
                SectionIconRow(iconName: "fuelpump.fill", circleValue: 1, progressValue: 0) {
                    Text("Informationstyp")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.secondary)
                    Text("Getankt")
                        .fontWeight(.semibold)
                }
                .padding(20)
                .background(.ultraThinMaterial)
                .backgroundStyle(cornerRadius: 30)
                .padding(20)
                .padding(.top, -60)
                //            .padding(.top, verticalSizeClass == .compact ? 0 : 80)
                
                SectionIconRow(iconName: "flame", circleValue: 1, progressValue: 0) {
                    Text("Menge")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.secondary)
                    Text(Measurement<UnitVolume>(value: entry.refuel?.liters ?? -1, unit: .liters).formatted(.measurement(width: .abbreviated, usage: .asProvided, numberFormatStyle:.number.precision(.fractionLength(2)).grouping(.never))))
                        .fontWeight(.semibold)
                }
                .padding(20)
                .background(.ultraThinMaterial)
                .backgroundStyle(cornerRadius: 30)
                .padding(20)
                .padding(.top, -40)
                //            .padding(.top, verticalSizeClass == .compact ? 0 : 80)
                
                SectionImageRow(imageName: "eurosign", circleValue: 1, progressValue: 0) {
                    Text("Kosten")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.secondary)
                    Text(entry.refuel?.price.formatted(.currency(code: "EUR")) ?? "-1")
                        .fontWeight(.semibold)
                }
                .padding(20)
                .background(.ultraThinMaterial)
                .backgroundStyle(cornerRadius: 30)
                .padding(20)
                .padding(.top, -40)
            }
            

        }
    }
}

#Preview {
    AddInfoSection(entry: LogbookEntry.previewData.data[0])
}
