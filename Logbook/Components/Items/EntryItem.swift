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
                .padding(.bottom, -45)

            
                VStack(alignment: .leading, spacing: 1) {
                    GeometryReader { metrics in
                        Text(entry.driveReason)
                            .font(.title3).bold()
                            .frame(maxWidth: metrics.size.width * 0.7, alignment: .leading)
                            .lineLimit(0)
                            .truncationMode(.tail)
                            .allowsTightening(true)
                            .matchedGeometryEffect(id: "title\(entry.id)", in: namespace)
                            .foregroundColor(.white)
                    }
                    .padding(.bottom, 15)
                    
                    Text("\(DateFormatter.readableDeShort.string(from: entry.date)) - \(entry.driver.rawValue)".uppercased())
                        .font(.footnote).bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .matchedGeometryEffect(id: "subtitle\(entry.id)", in: namespace)
                        .foregroundColor(.white.opacity(0.7))
                    //                                    .background {
                    //                                        Rectangle()
                    //                                            .fill(.ultraThinMaterial)
                    //                                            .frame(maxHeight: .infinity, alignment: .bottom)
                    //                                            .cornerRadius(1)
                    //                                            .blur(radius: 20)
                    //                                            .transition(.opacity)
                    //                                    }
                }
                .padding(20)
            }
            .background(
                Image(getVehicleIcon(vehicleTyp: entry.vehicleTyp))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
                    .matchedGeometryEffect(id: "image\(entry.id)", in: namespace)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                //                .padding(.horizontal, -10)
                //                .padding(.vertical, -20)
            )
            .background(.secondary.opacity(0.4))
            .background(.ultraThinMaterial)
            .background(
                Image(getVehicleBackground(vehicleTyp: entry.vehicleTyp))
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: 150, alignment: .center)
                    .disabled(true)
                    .matchedGeometryEffect(id: "background\(entry.id)", in: namespace)
            )
            .clipped()
            .contentShape(RoundedRectangle(cornerRadius: CGFloat(30)))
            .mask(
                RoundedRectangle(cornerRadius: 30)
                    .matchedGeometryEffect(id: "mask\(entry.id)", in: namespace)
            )
            //        .frame(maxWidth: .infinity, maxHeight: 100)
            
            //                .overlay(
            //                    Image(horizontalSizeClass == .compact ? "Waves 1" : "Waves 2")
            //                        .frame(maxHeight: .infinity, alignment: .bottom)
            //                        .offset(y: 0)
            //                        .opacity(0.2)
            //                        .matchedGeometryEffect(id: "waves\(entry.id)", in: namespace)
            //                )
            //                .frame(maxHeight: 150)
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
//        EntryItem(namespace: namespace, entry: LogbookEntry.previewData[1])
//            .environmentObject(Model())
////                        .frame(height: 100)
                ListView(logbooks: LogbookEntry.previewData, showAdd: .constant(false), lastRefreshDate: .constant(Date()))
        .environmentObject(Model())
        .environmentObject(NetworkReachability())
    }
}
