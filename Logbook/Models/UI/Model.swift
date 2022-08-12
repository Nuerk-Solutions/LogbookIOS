//
//  Model.swift
//  Logbook
//
//  Created by Thomas on 28.05.22.
//

import Foundation
import SwiftUI
import CoreLocation

class Model: ObservableObject {
    @Published var showNav: Bool = true
    @Published var showTab: Bool = true
    @Published var showAdd: Bool = false
    @Published var lastAddedEntry: Date = Date.distantPast
    
    // Detail View
    @Published var showDetail: Bool = false
    @Published var selectedEntry: UUID = UUID()
}

let homeCoordinates: CLLocation = CLLocation(latitude: 51.0365271, longitude: 13.6883357)
