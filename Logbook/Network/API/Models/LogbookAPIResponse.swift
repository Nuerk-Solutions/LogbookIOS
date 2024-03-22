//
//  LogbookAPIResponse.swift
//  Logbook
//
//  Created by Thomas on 26.05.22.
//

import Foundation

struct LogbookAPIResponse: Decodable {
    
    let total, length, limit, pageCount: Int
    let page: Int?
    let data: [LogbookEntry]
}
