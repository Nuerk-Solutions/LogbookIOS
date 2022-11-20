//
//  LogbookAPIResponse.swift
//  Logbook
//
//  Created by Thomas on 26.05.22.
//

import Foundation

struct LogbookAPIResponse: Decodable {
    
    let total: Int
    let length: Int
    let limit: Int
    let page: Int?
    let pageCount: Int
    let data: [LogbookEntry]?
}
