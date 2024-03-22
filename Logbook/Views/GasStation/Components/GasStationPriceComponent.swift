//
//  PriceSSView.swift
//  Logbook
//
//  Created by Thomas on 18.06.22.
//

import SwiftUI

struct GasStationPriceComponent: View {
    
    var price: Double = 1.899
    
    @AppStorage("isUseNotSuperScript") var isUseNotSuperScript = false
    
    let currencyFormatter: NumberFormatter = {
       let formatter = NumberFormatter()
        formatter.locale = Locale.init(identifier: "de") // MARK: Test if .current work here
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    var body: some View {
        if !isUseNotSuperScript {
            let superScriptNumber = price.description.compactMap { $0 == "." ? nil : $0}.last?.description ?? "FEHLER!"
            Text("\(currencyFormatter.string(from: price as NSNumber)!)")
                .fontWeight(.semibold)
            +
            Text("\(superScriptNumber)")
                .font(.caption)
                .baselineOffset(6)
            +
            Text("€")
        } else {
            Text("\(price, format: .currency(code: "EUR"))")
                .fontWeight(.semibold)
        }
    }
}

struct PriceView_Previews: PreviewProvider {
    static var previews: some View {
        GasStationPriceComponent()
            .environment(\.locale, .init(identifier: "de"))
    }
}
