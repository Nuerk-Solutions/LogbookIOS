//
//  UrlExtension.swift
//  Logbook
//
//  Created by Thomas on 03.05.22.
//

import Foundation

extension URL {
    var isDepplink: Bool {
        return scheme == "logbookapp"
    }
    
    var driverIdentifier: DriverEnum? {
        guard isDepplink else { return nil }
        
        return DriverEnum(rawValue: host ?? "")
    }
    
    var startDateIdentifier: Date? {
        guard pathComponents.count > 1, let date = DateFormatter.standardT.date(from: pathComponents[1]) else {
            return nil
        }
        
        return date
    }
    
    var endDateIdentifier: Date? {
        guard pathComponents.count > 2, let date = DateFormatter.standardT.date(from: pathComponents[2]) else {
            return nil
        }
        
        return date
    }
}
