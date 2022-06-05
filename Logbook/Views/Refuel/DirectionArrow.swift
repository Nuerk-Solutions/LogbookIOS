//
//  DirectionArrow.swift
//  Logbook
//
//  Created by Thomas on 05.06.22.
//

import SwiftUI
import CoreLocation

struct DirectionArrow: View {
    
    
    var station: StationModel
    @Binding var heading: Double
    
    
    var body: some View {
        let diff = Int(heading - station.bearing! + 180 + 360) % 360 - 180
        
        Image(systemName: "arrow.up")
            .resizable()
            .scaledToFit()
            .frame(width: 35, height: 35, alignment: .center)
            .foregroundColor(
                diff <= 70 && diff >= -70 ? .green : .red
            )
            .rotationEffect(Angle(degrees: (station.bearing ?? 0) - heading))
    }
}


struct DirectionArrow_Previews: PreviewProvider {
    static var previews: some View {
        DirectionArrow(station: StationModel.item, heading: .constant(0))
    }
}
