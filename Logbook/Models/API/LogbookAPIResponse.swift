//
//  LogbookAPIResponse.swift
//  Logbook
//
//  Created by Thomas on 26.05.22.
//

import Foundation

struct LogbookAPIResponse: Decodable {
    
    let status: String
    let totalResults: Int?
    let logbooks: [LogbookEntry]?
    
    let code: String?
    let message: String?
    
}
