//
//  Voucher.swift
//  Logbook
//
//  Created by Thomas Nürk on 29.02.24.
//

import Foundation

// TODO: Split up voucher struct into chunks, so e.g. only the code is sent when reedeming a voucher

struct Voucher: Codable, Hashable {
    
    init(code: String, value: Int, distance: Int, remainingDistance: Int, expiration: Date, isExpired: Bool, creator: DriverEnum, redeemed: Bool) {
        self._id = ""
        self.code = code
        self.value = value
        self.distance = distance
        self.remainingDistance = remainingDistance
        self.expiration = expiration
        self.isExpired = isExpired
        self.creator = creator
        self.redeemed = redeemed
    }
    
    init(code: String, value: Int, expiration: Date, creator: DriverEnum) {
        self.init(code: code, value: value, distance: -1, remainingDistance: -1, expiration: expiration, isExpired: false, creator: creator, redeemed: false)
    }
    
    init(code: String) {
        self.init(code: code, value: -1, expiration: Date(), creator: .Andrea)
    }
    let _id: String?
    let code: String
    let value: Int
    let distance: Int
    let remainingDistance: Int
    let expiration: Date
    let isExpired: Bool
    let creator: DriverEnum
    let redeemed: Bool
}

extension Voucher {
    
    static var previewData: [Voucher] {
        let previewDataURL = Bundle.main.url(forResource: "vouchers", withExtension: "json")!
        let data = try! Data(contentsOf: previewDataURL)
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(.iso8601Full)
        
        let apiResponse = try! jsonDecoder.decode([Voucher].self, from: data)
        
        return apiResponse
    }
}
