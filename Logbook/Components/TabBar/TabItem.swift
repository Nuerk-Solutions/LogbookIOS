//
//  TabModel.swift
//  Logbook
//
//  Created by Thomas Nürk on 05.03.24.
//

import SwiftUI

struct TabItem: Identifiable {
    let id = UUID()
    var name: String
    var icon: String
    var color: Color
    var selection: Tab
}

var tabItems = [
    TabItem(name: "Übersicht", icon: "house", color: .accentColor, selection: .home),
    TabItem(name: "Tankstellen", icon: "fuelpump", color: .accentColor, selection: .gasStations),
    TabItem(name: "Statisitk", icon: "magnifyingglass", color: .accentColor, selection: .stats),
    TabItem(name: "Einstellungen", icon: "gear", color: .accentColor, selection: .settings)
]

enum Tab: String, CaseIterable {
    case home
    case gasStations
    case stats
    case settings
}
