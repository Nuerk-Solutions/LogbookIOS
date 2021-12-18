//
//  AdditionalInformation.swift
//  Logbook
//
//  Created by Thomas on 16.12.21.
//

import Foundation
import SwiftUI

struct AdditionalInformation: Codable, Identifiable {
    let id = UUID()
    
    var informationTyp: AdditionalInformationEnum?
    var inforamtion: String?
    var cost: String?
//    var distanceSinceLastInformation: Int?
}

enum AdditionalInformationEnum: String, Equatable, CaseIterable, Identifiable, Codable {
    case none = "Keine"
    case refuled = "Getankt"
    case service = "Gewartet"
    
    var id: String { self.rawValue }
    var localizedName: LocalizedStringKey { LocalizedStringKey(self.rawValue) }
}
