//
//  HelpView.swift
//  Logbook
//
//  Created by Thomas on 19.02.22.
//

import SwiftUI
import AlertKit

struct RefuelView: View {
    
    @StateObject var refuelViewModel = RefuelViewModel()
    @State private var selectedVehicle: VehicleEnum = VehicleEnum.Ferrari
    @StateObject var alertManager = AlertManager()
    @State private var heading: Double = 0.0
    @ObservedObject private var locationService: LocationService = LocationService()
    
    
    init() {
        UITableView.appearance().sectionFooterHeight = 0
    }
    
    
    var body: some View {
        NavigationView {
        Form {
            Section(header: Text("Informationen zum Tanken")) {
                Picker("Fahrzeug", selection: $selectedVehicle.animation()) {
                    ForEach(VehicleEnum.allCases) { vehicle in
                        Text(vehicle.id).tag(vehicle)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                VStack (alignment: .leading) {
                    Spacer()
                    Text("Was wird getankt?").font(.headline)
                    Spacer()
                    Text(selectedVehicle == .Ferrari ? "In den Ferrari wird nur E5, Super oder Super+ getankt." : selectedVehicle == .VW ? "In den VW wird nur Diesel getankt." : "In den Porsche wird nur Super+ getankt. Oliver übernimmt das Tanken!")
                    if(selectedVehicle == .Ferrari) {
                        Spacer()
                        Spacer()
                        Text("Kein E10, Super E10 oder Ad Blue").underline(true, color: .red).foregroundColor(.red)
                            .bold()
                    }
                    Spacer()
                    Spacer()
                }
            }
            .headerProminence(.increased)
            
            if Reachability.isConnectedToNetwork() {
                if(refuelViewModel.isLoading || refuelViewModel.patrolStations.stations.isEmpty) {
                    Text("Laden...")
                } else {
                    let detailFuelText: String = selectedVehicle == .Porsche ? "e10" : selectedVehicle == .Ferrari ? "e5" : "Diesel"
                    Section(header: Text("Tankstellen (\(detailFuelText))")) {
                        List(refuelViewModel.patrolStations.stations) { station in
                            RefuelRowView(station: station, selectedVehicle: $selectedVehicle, heading: $locationService.heading)
                        }
                    }
                    .headerProminence(.increased)
                }
            }
        }
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismissToRoot()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30, alignment: .center)
                }
            }
        })
        .navigationBarTitleDisplayMode(.inline)
        
        .uses(alertManager)
        
        .alert(isPresented: $refuelViewModel.showAlert, content: {
            Alert(title: Text("Fehler!"), message: Text(refuelViewModel.errorMessage ?? ""), dismissButton: .default(Text("OK")))
        })
        .onAppear {
            if !Reachability.isConnectedToNetwork() {
                refuelViewModel.errorMessage = "Bitte stelle sicher das du eine Verbindung zum Internet hast, um die mächsten Tankstellen anzuzeigen!"
                refuelViewModel.showAlert = true
                return
            }
            if locationService.authorizationStatus == .denied {
                refuelViewModel.showAlert = true
                refuelViewModel.errorMessage = "Bitte gib den Standort frei"
                return
            }
            locationService.locationManager.startUpdatingLocation()
        }
        .onDisappear {
            locationService.locationManager.stopUpdatingLocation()
        }
        .task({
            if locationService.hasPermission() {
                await refuelViewModel.fetchFuelPrice(fuelType: "e5", locationService: locationService)
            }
        })
        
        .onChange(of: selectedVehicle) { newVehicle in
            print(newVehicle)
            Task {
                await refuelViewModel.fetchFuelPrice(fuelType: newVehicle == .VW ? "diesel" : newVehicle == .Ferrari ? "e5" : "e10", locationService: locationService)
            }
        }
        .onChange(of: locationService.authorizationStatus, perform: { newValue in
            print(newValue)
            if newValue != .notDetermined && newValue != .denied {
                Task {
                    await refuelViewModel.fetchFuelPrice(fuelType: "e5", locationService: locationService)
                }
            } else {
                refuelViewModel.showAlert = true
                refuelViewModel.errorMessage = "Bitte gib den Standort frei"
            }
        })
        .onReceive(locationService.$heading, perform: { newValue in
            DispatchQueue.main.async {
                heading = newValue
            }
        })
        .overlay {
            if(refuelViewModel.isLoading) {
                CustomProgressView(message: "Laden...")
            }
        }
    }
    }
}


struct RefuelView_Previews: PreviewProvider {
    static var previews: some View {
        RefuelView()
        
    }
}
