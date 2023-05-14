//
//  GasStationsView.swift
//  Logbook
//
//  Created by Thomas on 18.06.22.
//

import SwiftUI
import CoreLocation

struct GasStationsView: View {
    
    @State var contentHasScrolled = false
    @State var scrollViewOffset: CGFloat = 0
    @AppStorage("selectedGasStationVehicle") var stationForVehicle: VehicleEnum = .Ferrari
    @AppStorage("gasStationSort") var gasStationSort: SortTyp = .Preis
    
    @StateObject private var locationManager = LocationManager()
    @StateObject var gasStationVM: GasStationViewModel
    
    
    init(gasStations stations: [GasStationEntry]? = nil) {
        self._gasStationVM = StateObject(wrappedValue: GasStationViewModel(gasStations: stations))
    }
    
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            content
                .background(Image("Blob 1").offset(x: -180, y: 300))
        }
        .task {
            await gasStationVM.loadGasStations()
        }
//        .onAppear {
//            locationManager.requestAuthorization()
//        }
        .onDisappear {
            gasStationVM.stopAllLocationUpdates()
        }
        //        ZStack {
        //            Color("Background").ignoresSafeArea()
        //        ScrollView {
        //
        //            scrollDetection
        //
        //            content
        //
        //            // [1.899, 1.939, 1.949, 1.959, 1.909]
        //
        //            //            .onAppear {
        //            //                var factorMap = [Double: Decimal]()
        //            //                var ratingMap = [String : Decimal]()
        //            //
        //            //                let dictonary = Dictionary(grouping: gasStations, by: {$0.price!})
        //            //                let sortedKeys = dictonary.keys.sorted()
        //            //
        //            //                stride(from: sortedKeys.first!, to: sortedKeys.last! + 0.01, by: 0.01).enumerated().forEach { index, item in
        //            //                    factorMap[item] = (pow(2, index) / 10 + 1)
        //            //                }
        //            //                gasStations.forEach { item in
        //            //                    let rating = factorMap[item.price!]! + Decimal(item.dist / 10)
        //            //                    ratingMap[item.id] = rating
        //            //                }
        //            //                let ratio = 1 / ratingMap.values.max()!
        //            //
        //            //                gasStations.forEach { item in
        //            //                    let test: Double = Double(ratio as NSNumber) * Double(ratingMap[item.id]! as NSNumber)
        //            //                }
        //            //
        ////                        }
        
        //                .sheet(isPresented: $showSection) {
        //                    SectionView(section: $selectedSection)
        //        }
        //        }
    }
    
    var content: some View {
        ScrollView {
            
            scrollDetection
              
                if !gasStations.isEmpty {
                    sectionsSection
                        .padding(.vertical, 70)
                        .padding(.bottom, 50)
                        .offset(y: 35)
                }
        }
        .coordinateSpace(name: "scroll")
        .overlay(NavigationBar(title: "Tankstellen", contentHasScrolled: $contentHasScrolled).disabled(contentHasScrolled))
        .overlay(overlayView)
        .overlay(pickerOverlay)
    }
    
    var pickerOverlay: some View {
        VStack {
            Picker("Fahrzeug", selection: $stationForVehicle) {
                ForEach(VehicleEnum.allCases) { vehicle in
                    Text(vehicle.rawValue)
                        .tag(vehicle)
                }
            }
            .pickerStyle(.segmented)
            .padding(15)
            .background(.ultraThinMaterial)
            .backgroundStyle(cornerRadius: 30)
            .padding(.horizontal, 20)
            .onChange(of: stationForVehicle) { newValue in
                Task {
                    await gasStationVM.loadGasStations()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .offset(y: 70)
        .offset(y: contentHasScrolled ? -30 : 0)
    }
    
    var sectionsSection: some View {
        VStack(spacing: 16) {
            let biggestDistance = gasStations.compactMap { $0.distance }.max() ?? 0.00
            let baseCircleRatio = 1 / (Double(gasStations.count))
//            let baseCircleRatio = 1 / (gasStationVM.ratingMap.values.max() ?? 1)
            ForEach(Array(gasStations.enumerated()), id: \.offset) { index, station in
                if index != 0 { Divider() }
                let circleValue = baseCircleRatio * Double(index)
//                let circleValue = Double(truncating: baseCircleRatio as NSNumber) * Double(truncating: gasStationVM.ratingMap[station.poiID]! as NSNumber) // Calculates the circle radius based on the rating Map
                let progressValue = (1 / biggestDistance) * station.distance // Calculates length of the progress line with the given distance
                
                GasStationRow(currentLocation: gasStationVM.currentLocation, heading: gasStationVM.currentHeading, station: station, circleValue: circleValue, progressValue: progressValue)
//                HStack(alignment: .top, spacing: 16) {
//                    Image(systemName: iconName ?? "flag")
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(width: 24, height: 24)
//                        .frame(width: 45, height: 45)
//                        .mask(Circle())
//                        .padding(6)
//                        .background(Color(UIColor.systemBackground).opacity(0.3))
//                        .mask(Circle())
//                        .overlay(CircularView(value: circleValue ?? 1))
//
//                    VStack(alignment: .leading, spacing: 8) {
//                        content
//                        if progressValue != 0 {
//                            ProgressView(value: progressValue)
//                                .accentColor(.white)
//                                .frame(maxWidth: 132)
//                        }
//                    }
//                    Spacer()
//                }
                

            }
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .backgroundStyle(cornerRadius: 30)
        .padding(20)
//        .padding(.vertical, 80)
    }
    
    
    var scrollDetection: some View {
        GeometryReader { proxy in
            let offset = proxy.frame(in: .named("scroll")).minY
            Color.clear.preference(key: ScrollPreferenceKey.self, value: offset)
        }
        .onPreferenceChange(ScrollPreferenceKey.self) { value in
            withAnimation(.easeInOut) {
                if value < 0 {
                    contentHasScrolled = true
                } else {
                    contentHasScrolled = false
                }
            }
        }
    }
    
    @ViewBuilder
    private var overlayView: some View {
        switch gasStationVM.phase {
        case .empty:
            CustomProgressView(message: "Suche nach Tankstellen")
        case .success(let gasStations) where gasStations.isEmpty:
            EmptyPlaceholderView(text: "Keine Tankstellen gefunden", image: Image(systemName: "fuelpump"))
        case .failure(let error):
            RetryView(text: error.localizedDescription, retryAction: refreshTask)
        default:
            EmptyView()
        }
    }
    
    @Sendable
    private func refreshTask() {
        Task {
            await gasStationVM.loadGasStations()
        }
    }
    
    private var gasStations: [GasStationEntry] {
        if case let .success(gasStations) = gasStationVM.phase {
            return gasStations
        } else {
            return gasStationVM.phase.value ?? []
        }
    }
    
}
struct GasStationsView_Previews: PreviewProvider {
    static var previews: some View {
        GasStationsView(gasStations: GasStationWelcome.previewData.data.tankstellen)
            .environment(\.locale, .init(identifier: "de"))
            .preferredColorScheme(.dark)
            .environmentObject(Model())
    }
}
