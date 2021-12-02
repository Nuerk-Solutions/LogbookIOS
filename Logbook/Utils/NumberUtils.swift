//
//  NumberUtils.swift
//  Logbook
//
//  Created by Thomas on 02.12.21.
//

import Foundation

class NumbersOnly: ObservableObject {
    
    init(value: String) {
        self.value = value
    }
    
    
    @Published var value: String {
        didSet {
            let filtered = value.filter { $0.isNumber }
            
            if value != filtered {
                value = filtered
            }
        }
    }
}
