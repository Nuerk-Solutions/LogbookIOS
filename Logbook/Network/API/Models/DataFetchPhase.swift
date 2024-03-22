//
//  DataFetchPhase.swift
//  Logbook
//
//  Created by Thomas on 26.05.22.
//

import Foundation

enum DataFetchPhase<T> {
    
    case empty
    case success(T)
    case fetchingNextPage(T)
    case failure(Error)
    
    var value: T? {
        if case .success(let value) = self {
            return value
        } else if case .fetchingNextPage(let value) = self {
            return value
        }
        return nil
    }
}

extension DataFetchPhase: Equatable {
    static func == (lhs: DataFetchPhase<T>, rhs: DataFetchPhase<T>) -> Bool {
        switch(lhs, rhs) {
        case (.empty, .empty):
            return true
        case ( .fetchingNextPage(_), .fetchingNextPage(_)):
            return true
        case (.failure(_), .failure(_)):
            return true
        default:
            return false
        }
    }
}
