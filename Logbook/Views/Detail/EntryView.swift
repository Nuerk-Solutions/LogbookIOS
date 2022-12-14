//
//  EntryView.swift
//  Logbook
//
//  Created by Thomas on 07.06.22.
//

import SwiftUI
import SwiftUI_Extensions

struct EntryView: View {
    
    
    var namespace: Namespace.ID
    @Binding var entry: LogbookEntry
    var isAnimated = true
    
    @State var viewState: CGSize = .zero
    @State var showSection = false
    @State var appear = [false, false, false]
    
    @State var show = false
    //    @State var selectedSection = courseSections[0]
    
    @EnvironmentObject var model: Model
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.presentationMode) var presentationMode
    
    let digitsFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale.init(identifier: "de") // MARK: Test if .current work here
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        return formatter
    }()
    
    var body: some View {
        ZStack {
            ScrollView {
                cover
                sectionsSection
                    .opacity(appear[2] ? 1 : 0)
                //
                if entry.additionalInformationTyp != .Keine {
                    Text("Zusätzliche Informationen".uppercased())
                        .padding(.top, 20)
                        .font(.footnote.weight(.semibold))
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(20)
                        .offset(y: -30)
                        .accessibilityAddTraits(.isHeader)
                        .padding(.horizontal, verticalSizeClass == .compact ? 25 : 0)
                    
                    additionalSection
                        .opacity(appear[2] ? 1 : 0)
                }
            }
            .coordinateSpace(name: "scroll")
            .background(Color("Background"))
            .mask(RoundedRectangle(cornerRadius: appear[0] ? 0 : 30))
            .mask(RoundedRectangle(cornerRadius: viewState.width / 3))
            .modifier(OutlineModifier(cornerRadius: viewState.width / 3))
            .shadow(color: Color("Shadow").opacity(0.5), radius: 30, x: 0, y: 10)
            .scaleEffect(-viewState.width/500 + 1)
            .background(Color("Shadow").opacity(viewState.width / 500))
            .background(.ultraThinMaterial)
            .gesture(isAnimated ? drag : nil)
            .ignoresSafeArea()
            
            Button {
                isAnimated ?
                withAnimation(.closeCard) {
                    model.showDetail = false
                    //                    model.selectedCourse = 0
                }
                : presentationMode.wrappedValue.dismiss()
            } label: {
                CloseButton()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .padding(20)
            .ignoresSafeArea()
            
            AdditionalInfoImageView(informationTyp: entry.additionalInformationTyp)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            //                .padding(20)
                .matchedGeometryEffect(id: "logo\(entry.id)", in: namespace)
                .ignoresSafeArea()
                .accessibility(hidden: true)
        }
        .zIndex(1)
        .onAppear { fadeIn() }
        .onChange(of: model.showDetail) { show in
            fadeOut()
        }
    }
    
    var cover: some View {
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
                    .offset(y: scrollY > 0 ? -scrollY : 0)
                    .scaleEffect(scrollY > 0 ? scrollY / 500 + 1 : 1)
                    .opacity(1)
                    .matchedGeometryEffect(id: "waves\(entry.id)", in: namespace)
                    .accessibility(hidden: true)
            )
            .overlay(
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
                                .matchedGeometryEffect(id: "subtitle\(entry.id)", in: namespace)
                        }
                        .padding(.bottom, 5)
                        
                        HStack {
                            Image("eurosign")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16, height: 16)
                                .padding(3)
                                .padding(.trailing, 1)
                                .cornerRadius(100)
                                .overlay(RoundedRectangle(cornerRadius: 100)
                                    .stroke(Color.black, lineWidth: 2))
                                .padding(.leading, 1)
                            
                            Text("\(entry.distanceCost) €")
                                .font(.body).bold()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(.primary.opacity(0.7))
                                .matchedGeometryEffect(id: "description\(entry.id)", in: namespace)
                        }
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
                        Image(systemName: entry.forFreeBool ? "checkmark.square.fill" : "x.square.fill")
                            .resizable()
                            .frame(width: 26, height: 26)
                            .cornerRadius(10)
                            .padding(8)
                            .background(.ultraThinMaterial)
                            .backgroundStyle(cornerRadius: 18, opacity: 0.4)
                            .foregroundColor(entry.forFreeBool ? .green : .red)
                        Text(entry.forFreeBool ? "Die Fahrt wird übernommen" : "Die Fahrt wird nicht übernommen.")
                            .font(.footnote.weight(.medium))
                            .foregroundStyle(.secondary)
                    }
                    .opacity(appear[1] ? 1 : 0)
                    .accessibilityElement(children: .combine)
                }
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
        .frame(height: verticalSizeClass == .compact ? 600 : 500)
    }
    
    var sectionsSection: some View {
        HStack {
            SectionIconRow(iconName: "flag", innerFrame: 18, outerFrame: 30, contentSpacing: 10, shouldSpace: true, circleValue: 1, progressValue: 0) {
                Text("Aktuell")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.secondary)
                Text("\(digitsFormatter.string(for: (entry.currentMileAge as NSString).integerValue)!) km")
                    .fontWeight(.semibold)
            }
            .padding(10)
            //            .background(.ultraThinMaterial)
            //            .backgroundStyle(cornerRadius: 30)
            //            .padding(20)
            //            .padding(.top, verticalSizeClass == .compact ? 0 : 80)
            
            SectionIconRow(iconName: "flag.fill", innerFrame: 18, outerFrame: 30, contentSpacing: 10, shouldSpace: false, circleValue: 1, progressValue: 0) {
                Text("Neu")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.secondary)
                
                Text("\(digitsFormatter.string(for: (entry.newMileAge as NSString).integerValue)!) km")
                    .fontWeight(.semibold)
                    .padding(.trailing, 15)
            }
            //            .padding(5)
            //            .background(.ultraThinMaterial)
            //            .backgroundStyle(cornerRadius: 30)
            //            .padding(20)
            //            .padding(.top, -40)
        }
        .padding(.horizontal, verticalSizeClass == .compact ? 25 : 0)
        .background(.ultraThinMaterial)
        .backgroundStyle(cornerRadius: 30)
        .padding(.top, verticalSizeClass == .compact ? 0 : 80)
        .padding(20)
        
    }
    
    var additionalSection: some View {
        Group {
            let description: String = entry.additionalInformationTyp == .Getankt ? "Menge" : "Beschreibung"
            let unit: String = entry.additionalInformationTyp == .Getankt ? "L" : ""
            let iconName: String = entry.additionalInformationTyp == .Getankt ? "fuelpump.fill" : "wrench.and.screwdriver"
            let detailedIconName: String = entry.additionalInformationTyp == .Getankt ? "flame" : "doc.text"
            
            SectionIconRow(iconName: iconName, circleValue: 1, progressValue: 0) {
                Text("Informationstyp")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.secondary)
                Text("\(entry.additionalInformationTyp.rawValue)")
                    .fontWeight(.semibold)
            }
            .padding(20)
            .background(.ultraThinMaterial)
            .backgroundStyle(cornerRadius: 30)
            .padding(20)
            .padding(.top, -60)
            //            .padding(.top, verticalSizeClass == .compact ? 0 : 80)
            
            SectionIconRow(iconName: detailedIconName, circleValue: 1, progressValue: 0) {
                Text(description)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.secondary)
                Text("\(entry.additionalInformation) \(unit)")
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
                Text("\((Double(entry.additionalInformationCost)?.formatted(.currency(code: "EUR").locale(Locale(identifier: "de-DE"))))!)")
                    .fontWeight(.semibold)
            }
            .padding(20)
            .background(.ultraThinMaterial)
            .backgroundStyle(cornerRadius: 30)
            .padding(20)
            .padding(.top, -40)
        }
        .padding(.horizontal, verticalSizeClass == .compact ? 25 : 0)
    }
    func close() {
        withAnimation {
            viewState = .zero
        }
        withAnimation(.closeCard.delay(0.2)) {
            model.showDetail = false
            //            model.selectedCourse = 0
        }
    }
    
    var drag: some Gesture {
        DragGesture(minimumDistance: 30, coordinateSpace: .local)
            .onChanged { value in
                guard value.translation.width > 0 else { return }
                
                if value.startLocation.x < 100 {
                    withAnimation {
                        viewState = value.translation
                    }
                }
                
                if viewState.width > 120 {
                    close()
                }
            }
            .onEnded { value in
                if viewState.width > 80 {
                    close()
                } else {
                    withAnimation(.openCard) {
                        viewState = .zero
                    }
                }
            }
    }
    
    func fadeIn() {
        withAnimation(.easeOut.delay(0.3)) {
            appear[0] = true
        }
        withAnimation(.easeOut.delay(0.4)) {
            appear[1] = true
        }
        withAnimation(.easeOut.delay(0.5)) {
            appear[2] = true
        }
    }
    
    func fadeOut() {
        withAnimation(.easeIn(duration: 0.1)) {
            appear[0] = false
            appear[1] = false
            appear[2] = false
        }
    }
}

struct EntryView_Previews: PreviewProvider {
    @Namespace static var namespace
    static var previews: some View {
        //                EntryView(namespace: namespace, entry: .constant(LogbookEntry.previewData[14]))
        ////                    .preferredColorScheme(.dark)
        ////                    .previewInterfaceOrientation(.landscapeRight)
        //                    .environmentObject(Model())
        
        EntryView(namespace: namespace, entry: .constant(LogbookEntry.previewData[1]))
            .environmentObject(Model())
        //            .preferredColorScheme(.dark)
    }
}
