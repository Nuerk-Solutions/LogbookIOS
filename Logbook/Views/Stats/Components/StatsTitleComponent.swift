//
//  StatsTitleComponent.swift
//  Logbook
//
//  Created by Thomas Nürk on 05.03.24.
//

import SwiftUI

struct StatsTitleComponent: View {
    
    @Binding var vehicleSelection: VehicleEnum
    @EnvironmentObject var chartVM: ChartViewModel
    @EnvironmentObject var nAIM: NetworkActivityIndicatorManager
    
    var body: some View {
        HStack {
            Text("Verbrauch - \(vehicleSelection.rawValue)")
                .font(.title2)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            if nAIM.isVisible {
                ProgressView()
                    .padding(.trailing, 5)
            }
            
            Menu(content: {
                Picker(selection: $vehicleSelection) {
                    ForEach(VehicleEnum.allCases) { vehicle in
                        HStack {
                            Image("\(getVehicleIcon(vehicleTyp: vehicle))")
                                .resizable()
                                .scaledToFill()
                            Text(vehicle.rawValue)
                        }
                        .tag(vehicle)
                    }
                } label: {}
                    .font(.body) // TODO: Check if .font does anything here
            }, label: {
                Image(systemName: "car.circle")
                    .resizable()
                    .frame(width: 28, height: 28)
            })
            .onChange(of: vehicleSelection) { oldValue, newValue in
                chartVM.updateLogbooks(for: [vehicleSelection])
                chartVM.animateGraph(fromChange: true)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    StatsTitleComponent(vehicleSelection: .constant(.Ferrari))
        .environmentObject(ChartViewModel())
        .environmentObject(NetworkActivityIndicatorManager())
}
