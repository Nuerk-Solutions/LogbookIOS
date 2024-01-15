//
//  DVDView.swift
//  Logbook
//
//  Created by Thomas Nürk on 01.01.24.
//

import SwiftUI

struct DVDComponent: View {
    
    @AppStorage("currentDriver") var currentDriver: DriverEnum = .Andrea
    @Binding var newLogbook: LogbookEntry
    
    var lastLogbooks: [LogbookEntry]
    
    var body: some View {
        VStack {
            HStack {
                DatePicker("Datum", selection: $newLogbook.date, in: (getLogbookForVehicle(lastLogbooks: lastLogbooks, vehicle: newLogbook.vehicle)?.date ?? Date())...Date())
                    .customFont(.body)

                
                Menu(content: {
                    Picker(selection: $newLogbook.driver) {
                        ForEach(DriverEnum.allCases) { driver in
                            Text(driver.rawValue)
                                .tag(driver)
                        }
                    } label: {}
                    .customFont(.body)
                }, label: {
                    Image(systemName: "person.circle")
                        .resizable()
                        .frame(width: 28, height: 28)
                })
            }
            
            VehicleView()
            .onChange(of: newLogbook.vehicle) {
                newLogbook.mileAge.unit = newLogbook.vehicle.unit
                newLogbook.mileAge.current = getLogbookForVehicle(lastLogbooks: lastLogbooks, vehicle: newLogbook.vehicle)?.mileAge.new ?? 0
            }
        }
    }
    
    @ViewBuilder
    func VehicleView() -> some View {
//        GeometryReader { proxy in
        Picker("", selection: $newLogbook.vehicle) {
                    ForEach(VehicleEnum.allCases) { vehicle in
                        Image("\(getVehicleIcon(vehicleTyp: vehicle))_32")
                            .tag(vehicle)
                            .frame(width: 32, height: 32)
                    }
                }
                .pickerStyle(.segmented)
//                .frame(width: proxy.size.width, height: 20)
//        }
    }
    
}
#Preview {
    DVDComponent(newLogbook: .constant(LogbookEntry.previewData.data[0]),  lastLogbooks: [])
}
