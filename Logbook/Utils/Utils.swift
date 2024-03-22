//
//  Utils.swift
//  Logbook
//
//  Created by Thomas Nürk on 05.03.24.
//

import Foundation

let dayAndMonth: DateFormatter = {
    var dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM"
    return dateFormatter
}()
