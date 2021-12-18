//
//  StringExtension.swift
//  Logbook
//
//  Created by Thomas on 18.12.21.
//

import Foundation

extension String {
    
    var numberOfLines: Int {
        return self.components(separatedBy: "\n").count
    }
}
