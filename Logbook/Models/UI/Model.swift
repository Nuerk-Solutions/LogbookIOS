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
    @Published var showAdd: Bool = false
    @Published var lastAddedEntry: Date = Date.distantPast
    
    // Detail View
    @Published var showDetail: Bool = false
}

let homeCoordinates: CLLocation = CLLocation(latitude: 51.0365271, longitude: 13.6883357)
