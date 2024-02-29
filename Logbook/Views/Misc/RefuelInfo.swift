//
//  RefuelInfo.swift
//  Logbook
//
//  Created by Thomas Nürk on 15.01.24.
//

import SwiftUI

struct RefuelInfo: View {
    
    var fuelInformation: String = "Text here"
    var isAllowed: Bool = true
    var isPrefered: Bool = true
    
    var body: some View {
        HStack {
            Image(systemName: isAllowed ? "checkmark.circle.fill" : "xmark.circle.fill")
                .resizable()
                .scaledToFit()
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(isAllowed ? .green : .red)
                .symbolEffect(isPrefered ? .pulse.wholeSymbol : .pulse, options: isPrefered ? .speed(1) : .speed(0.001).nonRepeating)
                .frame(maxWidth: 24, maxHeight: 24)
            Text(fuelInformation)
                .frame(maxWidth: .infinity, alignment: .leading)
                .bold(isPrefered)
        }
    }
}

#Preview {
    RefuelInfo()
}
