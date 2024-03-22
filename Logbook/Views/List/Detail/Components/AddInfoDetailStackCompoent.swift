//
//  AddInfoDetailSectionComponent.swift
//  Logbook
//
//  Created by Thomas Nürk on 05.03.24.
//

import SwiftUI

struct AddInfoDetailStackCompoent: View {
    
    var entry: LogbookEntry
    
    var body: some View {
        Group {
            AddInfoDetailItemComponent(imageIconName: ifelse(service: "wrench.and.screwdriver", refuel: "fuelpump.fill"), title: "Informationstyp", subTitle: ifelse(service: "Wartung", refuel: "Getankt"), offSet: 60)
            
            AddInfoDetailItemComponent(imageIconName: ifelse(service: "doc.text", refuel: "flame"), title: ifelse(service: "Beschreibung", refuel: "Menge"), subTitle: ifelse(service:  entry.service?.message ?? "", refuel: Measurement<UnitVolume>(value: entry.refuel?.liters ?? -1, unit: .liters).formatted(.measurement(width: .abbreviated, usage: .asProvided, numberFormatStyle:.number.precision(.fractionLength(2)).grouping(.never)))), offSet: 40)
            
            AddInfoDetailItemComponent(imageIconName: "eurosign", title: "Kosten", subTitle: ifelse(service: entry.service?.price.formatted(.currency(code: "EUR")) ?? "-1", refuel: entry.refuel?.price.formatted(.currency(code: "EUR")) ?? "-1"), offSet: 40)
        }
    }
    
    func ifelse(service: String, refuel: String) -> String {
        entry.service != nil ? service : refuel
    }
}

#Preview {
    AddInfoDetailStackCompoent(entry: LogbookEntry.previewData.data.first!)
}
