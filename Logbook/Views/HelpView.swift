//
//  HelpView.swift
//  Logbook
//
//  Created by Thomas on 19.02.22.
//

import SwiftUI

struct HelpView: View {
    
    @StateObject var locationService: LocationService
    @StateObject var helpViewModel = HelpViewModel()
    
    var body: some View {
        Form {
            Section(header: Text("Ferrari")) {
                VStack (alignment: .leading) {
                    Spacer()
                    Text("Was wird getankt?").font(.headline)
                    Spacer()
                    Text("In den Ferrari wird nur E5, Super oder Super+ getankt.")
                    Spacer()
                    Spacer()
                    Text("Kein E10 oder Super E10 oder Ad Blue !").underline(true, color: .red).foregroundColor(.red)
                        .bold()
                    Spacer()
                    Spacer()
                }
            }.headerProminence(.increased)
            
            Section(header: Text("VW")) {
                VStack (alignment: .leading) {
                    Spacer()
                    Text("Was wird getankt?").font(.headline)
                    Spacer()
                    Text("In den VW wird nur Diesel getankt.")
                    Spacer()
                }
            }.headerProminence(.increased)
            
            Section(header: Text("Nächste günste Tanke")) {
                VStack (alignment: .leading) {
                    Spacer()
                    Text("Diesel").font(.headline)
                    Spacer()
                    Text("Lange Straße 99")
                    Spacer()
                }
                VStack (alignment: .leading) {
                    Spacer()
                    Text("Bezin E5").font(.headline)
                    Spacer()
                    Text("Lange Straße 99")
                    Spacer()
                }
            }.headerProminence(.increased)
            Section {
            if(!helpViewModel.isLoading) {
                List {
                    ForEach(helpViewModel.patrolStations.stations) { station in
                        Section {
                            NavigationLink {
                                AnyView(
                                    Text("Test")
                                )
                            } label: {
                                VStack(alignment: .leading) {
                                    Text("Name: \(station.name)")
                                    Text("Adr: \(station.street) \(station.houseNumber)")
                                    Text("Ent: \(station.dist, specifier: "%.2f") km")
                                    Text("Preis: \(station.price, specifier: "%.2f") Euro")
                                    Text("Offen: \(station.isOpen ? "Ja" : "Nein")")
                                    Text("Brand: \(station.brand)")
                                }
                            }
                        }
                    }
                }
            }
            }
        }
        .onAppear {
            Task {
                await helpViewModel.fetchFuelPrice(fuelType: "e5", locationService: locationService)
            }
        }
        .overlay {
            if(helpViewModel.isLoading) {
                ProgressView()
            }
        }
    }

}


//struct HelpView_Previews: PreviewProvider {
//    static var previews: some View {
//        HelpView()
//    }
//}
