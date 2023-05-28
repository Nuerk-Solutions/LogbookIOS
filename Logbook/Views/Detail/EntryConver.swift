//
//  EntryConver.swift
//  Logbook
//
//  Created by Thomas on 27.05.23.
//

import SwiftUI

struct EntryConver: View {
    
    var namespace: Namespace.ID
    @Binding var entry: logbook
    
    @Binding var appear: [Bool]
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var body: some View {
        GeometryReader { proxy in
            let scrollY = proxy.frame(in: .named("scroll")).minY
            
            VStack {
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .frame(height: scrollY > 0 ? 500 + scrollY : 500)
            .background(
                Image(getVehicleIcon(vehicleTyp: entry.vehicleTyp))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(20)
                    .matchedGeometryEffect(id: "image\(entry.id)", in: namespace)
                    .offset(y: -70)
                    .offset(y: scrollY > 0 ? -scrollY : 0)
                    .accessibility(hidden: true)
                //                    .frame(maxWidth: 150)
            )
            .background(
                Image(getVehicleBackground(vehicleTyp: entry.vehicleTyp))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .matchedGeometryEffect(id: "background\(entry.id)", in: namespace)
                    .offset(y: scrollY > 0 ? -scrollY : 0)
                    .scaleEffect(scrollY > 0 ? scrollY / 1000 + 1 : 1)
                    .blur(radius: scrollY > 0 ? scrollY / 10 : 0)
                    .accessibility(hidden: true)
            )
            .mask(
                RoundedRectangle(cornerRadius: appear[0] ? 0 : 30)
                    .matchedGeometryEffect(id: "mask\(entry.id)", in: namespace)
                    .offset(y: scrollY > 0 ? -scrollY : 0)
            )
            .overlay(
                Image(horizontalSizeClass != .compact || verticalSizeClass != .compact ? "Waves 1" : "Waves 2")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .offset(y: appear[3] ? 30 : 0)
                    .offset(y: scrollY > 0 ? -scrollY : 0)
                    .scaleEffect(scrollY > 0 ? scrollY / 500 + 1 : 1)
                    .opacity(1)
                    .matchedGeometryEffect(id: "waves\(entry.id)", in: namespace)
                    .accessibility(hidden: true)
            )
            .overlay(
                dataOverlay
                    .padding(20)
                    .padding(.vertical, 10)
                    .background(
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .frame(maxHeight: .infinity, alignment: .bottom)
                            .cornerRadius(30)
                            .blur(radius: 30)
                            .matchedGeometryEffect(id: "blur\(entry.id)", in: namespace)
                            .opacity(appear[0] ? 0 : 1)
                    )
                    .background(
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .backgroundStyle(cornerRadius: 30)
                            .opacity(appear[0] ? 1 : 0)
                    )
                    .offset(y: scrollY > 0 ? -scrollY * 1.8 : 0)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .offset(y: 100)
                    .padding(20)
                    .padding(.horizontal, verticalSizeClass == .compact ? 25 : 0)
            )
        }
        .background(.red)
        .frame(height: verticalSizeClass == .compact ? 600 : 500)
    }
    
    @ViewBuilder
    var dataOverlay: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(entry.driveReason)
                .font(.title3).bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.primary)
                .matchedGeometryEffect(id: "title\(entry.id)", in: namespace)
            
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Image(systemName: "person.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    
                    Text("\(entry.driver.rawValue)")
                        .font(.body).bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.primary.opacity(0.7))
                }
                .matchedGeometryEffect(id: "subtitle\(entry.id)", in: namespace)
                .padding(.bottom, 5)
                
                HStack {
                    Image("eurosign")
                        .resizable()
                        .background(.clear)
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .padding(3)
                        .padding(.trailing, 1)
                        .cornerRadius(100)
                        .overlay(RoundedRectangle(cornerRadius: 100)
                            .stroke(Color.primary, lineWidth: 2))
                        .padding(.leading, 1)
                    
                    Text("\(entry.distanceCost) €")
                        .font(.body).bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.primary.opacity(0.7))
                }
                .matchedGeometryEffect(id: "description\(entry.id)", in: namespace)
                .padding(.bottom, 5)
                
                HStack {
                    Image(systemName: "road.lanes")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    
                    Text("\(entry.distance) km")
                        .font(.body).bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.primary.opacity(0.7))
//                                .matchedGeometryEffect(id: "description\(entry.id)", in: namespace)
                }
                .opacity(appear[1] ? 1 : 0)
                //                        Text("\(DateFormatter.readableDeShort.string(from: entry.date))".uppercased())
                //                            .font(.footnote).bold()
                //                            .frame(maxWidth: .infinity, alignment: .leading)
                //                            .foregroundColor(.primary.opacity(0.7))
                //                            .matchedGeometryEffect(id: "description\(entry.id)", in: namespace)
            }
            
            //                    Text("Bei dieser Fahrt wurden \(entry.distance)km zu einem Preis von \(entry.distanceCost)€ gefahren.")
            //                        .font(.footnote)
            //                        .frame(maxWidth: .infinity, alignment: .leading)
            //                        .foregroundColor(.primary.opacity(0.7))
            //                        .matchedGeometryEffect(id: "description\(1)", in: namespace)
            
            Divider()
                .foregroundColor(.secondary)
                .opacity(appear[1] ? 1 : 0)
            
            HStack {
                Image(systemName: entry.forFree ?? false ? "checkmark.square.fill" : "x.square.fill")
                    .resizable()
                    .frame(width: 26, height: 26)
                    .cornerRadius(10)
                    .padding(8)
                    .background(.ultraThinMaterial)
                    .backgroundStyle(cornerRadius: 18, opacity: 0.4)
                    .foregroundColor(entry.forFree ?? false ? .green : .red)
                Text(entry.forFree ?? false ? "Die Fahrt wird übernommen" : "Die Fahrt wird nicht übernommen.")
                    .font(.footnote.weight(.medium))
                    .foregroundStyle(.secondary)
            }
            .opacity(appear[1] ? 1 : 0)
            .accessibilityElement(children: .combine)
        }
    }
}
