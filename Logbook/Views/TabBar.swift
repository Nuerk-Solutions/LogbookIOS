//
//  TabView.swift
//  Logbook
//
//  Created by Thomas on 22.04.22.
//

import SwiftUI

struct TabBar: View {
    var body: some View {
        TabView {
            ListView()
                .tabItem {
                    Label("Einträge", systemImage: "house")
                }
            
            InvoiceView()
                .tabItem {
                    Label("Abrechnung", systemImage: "creditcard")
                }
            
            SettingsView()
                .tabItem {
                    Label("Einstellungen", systemImage: "gear")
                }
        }
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
            .environmentObject(ListViewModel())
    }
}
