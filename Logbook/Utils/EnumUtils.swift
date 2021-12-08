//
//  EnumUtils.swift
//  Logbook
//
//  Created by Thomas on 02.12.21.
//

import Foundation
import SwiftUI

enum DriverEnum: String, CaseIterable, Identifiable, Codable {
    case Andrea
    case Claudia
    case Oliver
    case Thomas
    
    var id: String { self.rawValue }
}

enum VehicleEnum: String, CaseIterable, Identifiable, Codable {
    case Ferrari
    case VW
    
    var id: String { self.rawValue }
}

enum AdditionalInformationEnum: String, Equatable, CaseIterable, Identifiable, Codable {
    case none = "Keine"
    case refuled = "Getankt"
    case service = "Gewartet"
    
    var id: String { self.rawValue }
    var localizedName: LocalizedStringKey { LocalizedStringKey(self.rawValue) }
}
