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
    @EnvironmentObject private var locationService: LocationService
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Form {
            Section(header: Text("Informationen zum Tanken")) {
                Picker("Fahrzeug", selection: $selectedVehicle) {
                    ForEach(VehicleEnum.allCases) { vehicle in
                        Text(vehicle.id).tag(vehicle)
                    }
                }
                .onChange(of: selectedVehicle) { newVehicle in
                    print(newVehicle)
                    Task {
                        await refuelViewModel.fetchFuelPrice(fuelType: newVehicle == .VW ? "diesel" : "e5", locationService: locationService)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                VStack (alignment: .leading) {
                    Spacer()
                    Text("Was wird getankt?").font(.headline)
                    Spacer()
                    Text(selectedVehicle == .Ferrari ? "In den Ferrari wird nur E5, Super oder Super+ getankt." : "In den VW wird nur Diesel getankt.")
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
            
            
            if(refuelViewModel.isLoading || refuelViewModel.patrolStations.stations.isEmpty) {
                Text("Laden...")
            } else {
                    Section(header: Text("Tankstellen")) {
                            List {
                                ForEach(refuelViewModel.patrolStations.stations) { station in
                                    let price: String = "\(station.price)"
                                    let price_1 = price[price.index(price.startIndex, offsetBy: 0)..<price.index(price.startIndex, offsetBy: 4)]
                                    let price_2 = price[price.index(price.startIndex, offsetBy: 4)..<price.index(price.startIndex, offsetBy: 5)]
                                    Section {
                                        Button {
                                            openMaps(latitude: station.lat, longitude: station.lng, title: station.name)
                                        } label: {
                                            
                                            VStack(alignment: .leading) {
                                                Text("\(station.brand)").font(.callout).underline()
                                                Spacer()
                                                HStack(spacing: 2) {
                                                    Text("Preis: ")
                                                    Text("\(String(price_1))").bold()
                                                    Text("\(String(price_2))").font(.caption2).offset(y: -5)
                                                    Text("€")
                                                }
                                                Text("Entfernung: \(station.dist, specifier: "%.2f") km")
                                                Spacer()
                                                Text("\(station.street) \(station.houseNumber)").font(.subheadline)
                                                if(!station.isOpen) {
                                                    Text("Tankstelle geschlossen!").foregroundColor(.red).bold()
                                                }
                                                Spacer()
                                            }
                                        }
                                        .foregroundColor(.primary)
                                    }
                                }
                        }
                    }
                    .headerProminence(.increased)
            }
        }
        
        .uses(alertManager)
        
        .alert(isPresented: $refuelViewModel.showAlert, content: {
            Alert(title: Text("Fehler!"), message: Text(refuelViewModel.errorMessage ?? ""), dismissButton: .default(Text("OK"), action: {
                self.presentationMode.wrappedValue.dismiss()
            }))
        })
        .onAppear {
                Task {
                    await refuelViewModel.fetchFuelPrice(fuelType: "e5", locationService: locationService)
                }
        }
        .overlay {
            if(refuelViewModel.isLoading) {
                CustomProgressView(message: "Laden...")
            }
        }
    }
    
    func openMaps(latitude: Double, longitude: Double, title: String?) {
        let application = UIApplication.shared
        let coordinate = "\(latitude),\(longitude)"
        let encodedTitle = title?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let handlers = [
            ("Apple Maps", "http://maps.apple.com/?q=\(encodedTitle)&ll=\(coordinate)"),
            ("Google Maps", "comgooglemaps://?q=\(coordinate)"),
            ("Safari", "https://www.google.com/maps/dir/?api=1&destination=\(coordinate)&travelmode=driving")
        ]
            .compactMap { (name, address) in URL(string: address).map { (name, $0) } }
            .filter { (_, url) in application.canOpenURL(url) }

        guard handlers.count > 1 else {
            if let (_, url) = handlers.first {
                application.open(url, options: [:])
            }
            return
        }
        
        var buttons: [ActionSheet.Button] = []
        handlers.forEach { (name, url) in
            buttons.append(
                  .default(Text(name), action: {
                        application.open(url, options: [:])
                    })
            )
        }
        buttons.append(.cancel(Text("Abbrechen")))
        alertManager.showActionSheet(.custom(title: "App auswählen", message: "Wähle eine App für die Navigation aus.", buttons: buttons))
    }
    
}


struct RefuelView_Previews: PreviewProvider {
    static var previews: some View {
        RefuelView()
        
    }
}
