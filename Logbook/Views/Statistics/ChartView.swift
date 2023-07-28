//
//  ChartView.swift
//  Logbook
//
//  Created by Thomas on 09.09.22.
//

import SwiftUI
import SwiftUICharts

struct ChartView: View {
    
    @StateObject private var chartModel = ChartViewModel()
    @State private var data: [Double] = []
    @State private var newData: [(String, Double)] = []
    @State private var selectedCar: VehicleEnum = .Ferrari
    var body: some View {
        VStack {
//            GroupBox {
//                DisclosureGroup("Menu 1") {
//                    Text("Item 1")
//                    Text("Item 2")
//                    Text("Item 3")
//                }
//            }
            Picker(selection: $selectedCar) {
                ForEach(VehicleEnum.allCases) { vehicle in
                    Text(vehicle.rawValue)
                        .tag(vehicle)
                }
            } label: {
                Text("Fahrzeug")
            }
            .pickerStyle(.segmented)
            .padding(15)
            .onChange(of: selectedCar) { newValue in
                newData = chartModel.allLogbooks.filter({ item in
                    item.vehicleTyp == selectedCar && item.additionalInformationTyp == .Getankt
                }).reversed().map ({item in
                    let distance = item.distanceSinceLastAdditionalInformation
                    return ("\(distance)", Double(distance) ?? 0)
                })
            }

            BarChartView(data: ChartData(values: newData), title: "Entfernung seit Aktion", legend: "Datum", form: ChartForm.extraLarge, dropShadow: true, animatedToBack: true)
        }
            .task {
                await chartModel.loadLogbooks()
                newData = chartModel.allLogbooks.filter({ item in
                    item.vehicleTyp == selectedCar && item.additionalInformationTyp == .Getankt
                }).reversed().map ({item in
                    let distance = item.distanceSinceLastAdditionalInformation
                    return ("\(distance)", Double(distance) ?? 0)
                })
            }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView()
    }
}
