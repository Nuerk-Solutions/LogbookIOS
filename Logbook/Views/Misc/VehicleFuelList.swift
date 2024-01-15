//
//  VehicleFuelList.swift
//  Logbook
//
//  Created by Thomas Nürk on 15.01.24.
//

import SwiftUI

struct VehicleFuelList: View {
    
    var body: some View {
        List {
            ForEach(VehicleEnum.allCases) { vehicle in
                RefuelInfoList(vehicle: vehicle)
            }
        }
    }
}

#Preview {
    VehicleFuelList()
}
