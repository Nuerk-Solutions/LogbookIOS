//
//  InvoiceDetailSectionComponent.swift
//  Logbook
//
//  Created by Thomas on 23.04.22.
//

import SwiftUI

struct InvoiceDetailSectionComponent: View {
    
    let name: String
    var text: String = ""
    var distance: Int = 0
    var cost: Double? = nil
    
    private let numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale(identifier: "de_DE")
        numberFormatter.currencyCode = "EUR"
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter
    }()
    
    init(name: String, text: String = "", distance: Int = 0, cost: Double? = nil, digits: Int? = 2) {
        self.name = name
        self.text = text
        self.distance = distance
        self.cost = cost
        numberFormatter.maximumFractionDigits = digits!
    }
    
    var body: some View {
        HStack {
            Text(name)
            Spacer()
            if cost != nil && distance == 0 {
                Text("\(numberFormatter.string(from: NSNumber(value: cost!)) ?? "0 €")")
            } else if(text != ""){
                Text("\(text)")
            } else {
                Text("\(distance) km")
            }
        }
    }
}

struct InvoiceDetailSectionComponent_Previews: PreviewProvider {
    static var previews: some View {
        InvoiceDetailSectionComponent(name: "Fahrtkosten", distance: 5)
    }
}
