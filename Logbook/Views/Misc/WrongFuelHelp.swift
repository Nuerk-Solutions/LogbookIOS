//
//  WrongFuelHelp.swift
//  Logbook
//
//  Created by Thomas Nürk on 16.01.24.
//

import SwiftUI

struct WrongFuelHelp: View {
    @State private var expanded: Set<String> = []
    var body: some View {
        Form {
            Section("Benzin statt Diesel getankt?") {
                Text("Tanken von Benzin bei Diesel-Autos führt zu massiven Defekten. Wenn man es bemerkt hat sofort **Motor abstellen** bzw. besser **gar nicht erst starten**. Per Abschleppfahrzeug in die Werkstatt.")
            }
            .headerProminence(.increased)
            Section("Diesel statt Benzin getankt?") {
                Text("Tanken von Diesel bei Benzin-Autos führt zu massiven Defekten. Wenn man es bemerkt hat sofort **Motor abstellen** bzw. besser **gar nicht erst starten**. Per Abschleppfahrzeug in die Werkstatt.")
            }
            .headerProminence(.increased)
            Section("Falsche Benzinsorte getankt?") {
                DisclosureGroup("Verhalten im Regelfall") {
                    Text("Hier kann man in der Regel vorsichtig fahren (**kein Vollgas**, vor allem keine Höchstgeschwindigkeit auf der Autobahn), bis der Tank z.B. halbleer ist, und dann mit der richtigen Sorte wieder auffüllen, so vermischt sich das richtige Benzin mit der falschen Sorte und „verdünnt“ diese.")
                }
                DisclosureGroup("Versehentlich E10 getankt") {
                    DisclosureGroup("Wenn Vollgetankt") {
                        Text("**Umgehend** nach Hause fahren und Tank per Schlauch möglichst weit absaugen.\nDanach weiteres verfahren dann so weiter so verfahren wie im Punkt *Wenn nicht Vollgetankt* beschrieben.")
                    }
                    DisclosureGroup("Wenn nicht Vollgetankt") {
                            Text("**Umgehend** mit Shell-VPower100, Aral Ultimate 102 oder ähnlichem auffüllen, diese verdünnen das „E10“ gut.")
                    }
                }
            }
            .headerProminence(.increased)
        }
    }
}

#Preview {
    WrongFuelHelp()
}
