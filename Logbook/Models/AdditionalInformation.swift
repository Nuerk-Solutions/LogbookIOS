//
//  AdditionalInformation.swift
//  Logbook
//
//  Created by Thomas on 16.12.21.
//

import Foundation

struct AdditionalInformation: Codable, Identifiable {
    let id = UUID()
    
    var informationTyp: AdditionalInformationEnum?
    var inforamtion: String?
    var distanceSinceLastInformation: Int?
}
