//
//  EntryItem.swift
//  Logbook
//
//  Created by Thomas on 07.06.22.
//

import SwiftUI
import SwiftUI_Extensions

struct EntryItem: View {
    
    var namespace: Namespace.ID
    var entry: LogbookEntry
    
    @EnvironmentObject var model: Model
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        VStack {
            AdditionalInfoImageView(informationTyp: entry.additionalInformationTyp)
                .matchedGeometryEffect(id: "logo\(entry.id)", in: namespace)
            Spacer()
            
            VStack(alignment: .leading, spacing: 8) {
                Text(entry.driveReason)
                    .font(.title).bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .matchedGeometryEffect(id: "title\(entry.id)", in: namespace)
                    .foregroundColor(.white)
                
                Text("\(entry.driver.rawValue) - \(entry.vehicleTyp.rawValue)".uppercased())
                    .font(.footnote).bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .matchedGeometryEffect(id: "subtitle\(entry.id)", in: namespace)
                    .foregroundColor(.white.opacity(0.7))
                
                Text(DateFormatter.readableDeShort.string(from: entry.date))
                    .font(.footnote)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.white.opacity(0.7))
                    .matchedGeometryEffect(id: "description\(entry.id)", in: namespace)
            }
            .padding(20)
            .background {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .cornerRadius(30)
                    .blur(radius: 50)
                    .matchedGeometryEffect(id: "blur\(entry.id)", in: namespace)
                    .transition(.opacity)
            }
        }
        .background(
            Image(getVehicleIcon(vehicleTyp: entry.vehicleTyp))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(20)
                .matchedGeometryEffect(id: "image\(entry.id)", in: namespace)
                .offset(y: -30)
        )
        .background(
            Image(getVehicleBackground(vehicleTyp: entry.vehicleTyp))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .disabled(true)
                .matchedGeometryEffect(id: "background\(entry.id)", in: namespace)
        )
        .mask(
            RoundedRectangle(cornerRadius: 30)
                .matchedGeometryEffect(id: "mask\(entry.id)", in: namespace)
        )
        .overlay(
            Image(horizontalSizeClass == .compact ? "Waves 1" : "Waves 2")
                .frame(maxHeight: .infinity, alignment: .bottom)
                .offset(y: 0)
                .opacity(0)
                .matchedGeometryEffect(id: "waves\(entry.id)", in: namespace)
        )
        .frame(maxHeight: 300)
        .onTapGesture {
            withAnimation(.openCard) {
                model.showDetail = true
                model.selectedEntry = entry.id
            }
        }
    }
}

struct EntryItem_Previews: PreviewProvider {
    @Namespace static var namespace
    
    static var previews: some View {
        EntryItem(namespace: namespace, entry: LogbookEntry.previewData.first!)
            .environmentObject(Model())
    }
}
