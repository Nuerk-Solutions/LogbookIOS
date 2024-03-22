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
    @AppStorage("selectedFuelTyp") var selectedFuelTyp: FuelTyp = .DIESEL
    @AppStorage("gasStationSort") var gasStationSort: SortTyp = .Preis
    
    @StateObject private var locationManager = LocationManager()
    @StateObject var gasStationVM: GasStationViewModel
    
    
    init(gasStations stations: [GasStationEntry]? = nil) {
        self._gasStationVM = StateObject(wrappedValue: GasStationViewModel(gasStations: stations))
    }
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Background").ignoresSafeArea()
                ScrollView {
                    VStack {
                        Picker("", selection: $selectedFuelTyp) {
                            ForEach(FuelTyp.apiCases) { fueltyp in
                                Text(fueltyp.apiName)
                                    .tag(fueltyp)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(15)
                        .background(.ultraThinMaterial)
                        .backgroundStyle(cornerRadius: 30)
                        .padding(.horizontal, 20)
                        .onChange(of: selectedFuelTyp) { oldVlue, anewValue in
                            Task {
                                await gasStationVM.loadGasStations()
                            }
                        }
                    }
                    if !gasStations.isEmpty {
                        sectionsSection
                    }
                }
                .navigationTitle("Tankstellen")
                .overlay(overlayView)
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
        }
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
                
                GasStationItem(currentLocation: gasStationVM.currentLocation, heading: gasStationVM.currentHeading, station: station, circleValue: circleValue, progressValue: progressValue)
                
                
            }
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .backgroundStyle(cornerRadius: 30)
        .padding(20)
    }
    
    
    @ViewBuilder
    private var overlayView: some View {
        switch gasStationVM.phase {
        case .empty:
            ZStack{}.onAppear {
                showSpinningAlert(title: "Suche nach Tankstellen")
            }
        case .success(let gasStations) where gasStations.isEmpty:
            EmptyPlaceholderView(text: "Keine Tankstellen gefunden", image: Image(systemName: "fuelpump"))
        case .failure(let error):
            RetryView(text: error.localizedDescription, retryAction: {
                Task {
                    await gasStationVM.loadGasStations()
                }
            })
        default:
            EmptyView()
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

