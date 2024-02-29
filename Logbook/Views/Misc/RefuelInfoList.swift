//
//  RefuelInfoList.swift
//  Logbook
//
//  Created by Thomas Nürk on 15.01.24.
//

import SwiftUI

struct RefuelInfoList: View {
    
    var vehicle: VehicleEnum = .Ferrari
    @AppStorage<Bool> var isExpanded: Bool
    
    init(vehicle: VehicleEnum = .Ferrari, isExpanded: Bool = true) {
        self.vehicle = vehicle
        self._isExpanded = AppStorage(wrappedValue: isExpanded, "\(vehicle)_expand_view")
    }
    
    var body: some View {
        Section(isExpanded: $isExpanded.animation()) {
            VStack(spacing: 5) {
                ForEach(FuelTyp.allNonApiCases, id: \.id) { item in
                    RefuelInfo(fuelInformation: item.rawValue, isAllowed: vehicle.fuelTyp.contains(item), isPrefered: vehicle.fuelTyp[0] == item)
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
        .listStyle(.sidebar)
        .headerProminence(.increased)

    }
}


#Preview {
    RefuelInfoList()
}
