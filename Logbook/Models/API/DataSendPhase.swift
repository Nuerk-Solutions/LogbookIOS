//
//  DataSendPhase.swift
//  Logbook
//
//  Created by Thomas on 05.08.22.
//

import Foundation

enum DataSendPhase<T> {
    
    case empty
    case sending
    case success
    case failure(Error)
    
//    var value: T? {
//        if case .success(let value) = self {
//            return value
//        }
//        return nil
//    }
}
