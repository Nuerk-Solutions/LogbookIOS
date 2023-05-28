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
    @Binding var entry: logbook
    var isAnimated = true
    
    @State var viewState: CGSize = .zero
    @State var showSection = false
    @State var appear = [false, false, false, true]
    
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
                EntryConver(namespace: namespace, entry: $entry, appear: $appear)
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
                //.padding(20)
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
    
    var sectionsSection: some View {
        HStack {
            SectionIconRow(iconName: "flag", innerFrame: 18, outerFrame: 30, contentSpacing: 10, shouldSpace: true, circleValue: 1, progressValue: 0) {
                Text("\(digitsFormatter.string(for: (entry.currentMileAge as NSString).integerValue)!) km")
                    .fontWeight(.semibold)
                    .padding(.top, 12)
            }
            .padding(5)
            //            .background(.ultraThinMaterial)
            //            .backgroundStyle(cornerRadius: 30)
            //            .padding(20)
            //            .padding(.top, verticalSizeClass == .compact ? 0 : 80)
            
            SectionIconRow(iconName: "flag.fill", innerFrame: 18, outerFrame: 30, contentSpacing: 10, shouldSpace: false, circleValue: 1, progressValue: 0) {
                
                Text("\(digitsFormatter.string(for: (entry.newMileAge as NSString).integerValue)!) km")
                    .fontWeight(.semibold)
                    .padding(.trailing, 15)
                    .padding(.top, 12)
            }
            //            .padding(5)
            //            .background(.ultraThinMaterial)
            //            .backgroundStyle(cornerRadius: 30)
            //            .padding(20)
            //            .padding(.top, -40)
        }
        .padding(5)
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
        appear[3] = true
        withAnimation(.easeOut.delay(0.3)) {
            appear[0] = true
        }
        withAnimation(.easeOut.delay(0.4)) {
            appear[1] = true
        }
        withAnimation(.easeOut.delay(0.5)) {
            appear[2] = true
        }
        withAnimation(.easeOut.delay(0.3)) {
            appear[3] = false
        }
    }
    
    func fadeOut() {
        withAnimation(.easeIn(duration: 0.1)) {
            appear[0] = false
            appear[1] = false
            appear[2] = false
            appear[3] = true
        }
    }
}
