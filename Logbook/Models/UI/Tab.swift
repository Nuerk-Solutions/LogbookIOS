//
//  Tab.swift
//  Logbook
//
//  Created by Thomas on 28.05.22.
//

import SwiftUI

struct TabItem: Identifiable {
    let id = UUID()
    var name: String
//    var icon: RiveViewModel
    var icon: String
    var color: Color
    var selection: Tab
}

var tabItems = [
//    TabItem(name: "Übersicht", icon: RiveViewModel(fileName: "icons", stateMachineName: "HOME_interactivity", artboardName: "HOME"), color: .teal, selection: .home),
//    TabItem(name: "Abrechnung", icon: RiveViewModel(fileName: "icons", stateMachineName: "SEARCH_Interactivity", artboardName: "SEARCH"), color: .blue, selection: .invoice),
//    TabItem(name: "Einstellungen", icon: RiveViewModel(fileName: "icons", stateMachineName: "USER_Interactivity", artboardName: "USER"), color: .red, selection: .settings)
    TabItem(name: "Übersicht", icon: "house", color: .teal, selection: .home),
    TabItem(name: "Tankstellen", icon: "fuelpump", color: .orange, selection: .gasStations),
    //TabItem(name: "Abrechnung", icon: "magnifyingglass", color: .blue, selection: .invoice),
    TabItem(name: "Einstellungen", icon: "gear", color: .red, selection: .settings)
]

enum Tab: String {
    case home
    case gasStations
    case invoice
    case settings
}
