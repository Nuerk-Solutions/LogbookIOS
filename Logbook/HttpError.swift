//
//  HttpError.swift
//  Logbook
//
//  Created by Thomas on 09.12.21.
//

import Foundation
enum HttpError: Error {
    case statusNot200
    case status500
    case statusOther
}
