//
//  RefuelRowView.swift
//  Logbook
//
//  Created by Thomas on 16.03.22.
//

import SwiftUI
import AlertKit

struct RefuelRowView: View {
    
    var station: StationModel
    @Binding var selectedVehicle: VehicleEnum
    @StateObject var alertManager = AlertManager()
    
    var body: some View {
        let price: String = "\(station.price!)"
        let price_1 = price[price.index(price.startIndex, offsetBy: 0)..<price.index(price.startIndex, offsetBy: 4)]
        let price_2 = price[price.index(price.startIndex, offsetBy: 4)..<price.index(price.startIndex, offsetBy: 5)]
        Section {
            Button {
                openMaps(latitude: station.lat, longitude: station.lng, title: station.name)
            } label: {
                ZStack {
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
                        Spacer()
                    }
                }
            }
            .listRowBackground(selectedVehicle == .Porsche && station.brand.lowercased().contains("shell") ? Color.orange.opacity(0.5) : Color(.secondarySystemGroupedBackground))
            .foregroundColor(.primary)
        }
        .uses(alertManager)
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

struct RefuelRowView_Previews: PreviewProvider {
    static var previews: some View {
        RefuelRowView(station: StationModel.item, selectedVehicle: .constant(.Porsche))
    }
}
