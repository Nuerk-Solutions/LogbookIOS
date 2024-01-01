//
//  DVDView.swift
//  Logbook
//
//  Created by Thomas Nürk on 01.01.24.
//

import SwiftUI

struct DVDComponent: View {
    
    @AppStorage("currentDriver") var currentDriver: DriverEnum = .Andrea
    @AppStorage("currentVehicle") var currentVehicle: VehicleEnum = .Ferrari
    @Binding var newLogbook: LogbookEntry
    var lastLogbooks: [LogbookEntry]
    
    var body: some View {
        Group {
            DatePicker("Datum", selection: $newLogbook.date, in: (getLogbookForVehicle(lastLogbooks: lastLogbooks, vehicle: newLogbook.vehicle)?.date ?? Date())...Date())
                .customFont(.body)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                Picker("", selection: $newLogbook.vehicle) {
                    ForEach(VehicleEnum.allCases) { vehicle in
                        Image("\(getVehicleIcon(vehicleTyp: vehicle))_32")
                            .tag(vehicle)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .customFont(.body)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Menu(content: {
                    Picker(selection: $newLogbook.driver) {
                        ForEach(DriverEnum.allCases) { driver in
                            Text(driver.rawValue)
                                .tag(driver)
                        }
                    } label: {
                        Text("TEST")
                    }
                    .customFont(.body)
                }, label: {
                    Image(systemName: "person.circle")
                        .resizable()
                        .frame(width: 24, height: 24)
                })
            }
//            .onChange(of: $newLogbook.vehicle) { newValue in
//                currentVehicle = newValue
//                newLogbook.mileAge.current = getLogbookForVehicle(vehicle: newValue)?.mileAge.new ?? 0
//            }
        }
    }
}

#Preview {
    DVDComponent(newLogbook: .constant(LogbookEntry.previewData.data[0]), lastLogbooks: [])
}
