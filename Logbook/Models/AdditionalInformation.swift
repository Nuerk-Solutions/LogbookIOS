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
    var information: String
    var cost: String
//    var distanceSinceLastInformation: Int?
    
    enum CodingKeys: String, CodingKey {
        case informationTyp = "informationTyp"
        case information = "information"
        case cost = "cost"
    }
}

enum AdditionalInformationEnum: String, Equatable, CaseIterable, Identifiable, Codable {
    case none = "Keine"
    case refuled = "Getankt"
    case service = "Gewartet"
    
    var id: String { self.rawValue }
    var localizedName: LocalizedStringKey { LocalizedStringKey(self.rawValue) }
}
