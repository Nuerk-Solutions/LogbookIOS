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
    @State var test: VehicleEnum = .Ferrari
    
    var lastLogbooks: [LogbookEntry]
    
    var body: some View {
        VStack {
            HStack {
                DatePicker("Datum", selection: $newLogbook.date, in: (getLogbookForVehicle(lastLogbooks: lastLogbooks, vehicle: newLogbook.vehicle)?.date ?? Date())...Date())
                    .font(.body)

                
                Menu(content: {
                    Picker(selection: $newLogbook.driver) {
                        ForEach(DriverEnum.allCases) { driver in
                            Text(driver.rawValue)
                                .tag(driver)
                        }
                    } label: {}
                        .font(.body)
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
        SegmentControlContainer(items: VehicleEnum.allCases, images: 
                            VehicleEnum.allCases.map { $0.rawValue + "_32" }, selectedItem: $newLogbook.vehicle)
    }
    
}
#Preview {
    DVDComponent(newLogbook: .constant(LogbookEntry.previewData.data[0]),  lastLogbooks: [])
}
