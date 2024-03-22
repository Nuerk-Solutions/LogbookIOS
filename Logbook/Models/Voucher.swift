//
//  Voucher.swift
//  Logbook
//
//  Created by Thomas Nürk on 29.02.24.
//

import Foundation

// TODO: Split up voucher struct into chunks, so e.g. only the code is sent when reedeming a voucher

struct Voucher: Codable, Hashable {
    
    init(code: String, value: Int, distance: Int, remainingDistance: Int, expiration: Date, isExpired: Bool, creator: DriverEnum, redeemed: Bool, usedValue: Double) {
        self._id = ""
        self.code = code
        self.value = value
        self.distance = distance
        self.remainingDistance = remainingDistance
        self.expiration = expiration
        self.isExpired = isExpired
        self.creator = creator
        self.redeemed = redeemed
        self.usedValue = usedValue
    }
    
    init(code: String, value: Int, expiration: Date, creator: DriverEnum) {
        self.init(code: code, value: value, distance: -1, remainingDistance: -1, expiration: expiration, isExpired: false, creator: creator, redeemed: false, usedValue: 0)
    }
    
    init(code: String, usedValue: Double) {
        self.init(code: code, value: -1, distance: -1, remainingDistance: -1, expiration: Date(), isExpired: false, creator: .Andrea, redeemed: false, usedValue: usedValue)
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
    var usedValue: Double?
}

struct VoucherResponse: Codable, Hashable {
    
    init(code: String, usedValue: Double) {
        self.code = code
        self.usedValue = usedValue
    }
    var code: String?
    var usedValue: Double?
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
