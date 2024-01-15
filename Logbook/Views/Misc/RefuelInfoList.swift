//
//  RefuelInfoList.swift
//  Logbook
//
//  Created by Thomas Nürk on 15.01.24.
//

import SwiftUI

struct RefuelInfoList: View {
    
    var vehicle: VehicleEnum = .Ferrari
    @State private var isExpanded: Bool = true
    
    var body: some View {
        Section(isExpanded: $isExpanded.animation()) {
            VStack(spacing: 5) {
                ForEach(FuelTyp.allNonApiCases, id: \.id) { item in
                    RefuelInfo(fuelInformation: item.rawValue, isAllowed: vehicle.fuelTyp == item)
                }
            }
        } header: {
            HStack {
                Image(vehicle.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50, alignment: .center)
                Text(vehicle.rawValue)
            }
        }
        .headerProminence(.increased)

    }
}


#Preview {
    RefuelInfoList()
}
