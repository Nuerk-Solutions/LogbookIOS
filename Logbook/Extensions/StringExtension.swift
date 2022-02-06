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
    
    func isInt() -> Bool {
        
        if let _ = Int(self) {
            return true
        }
        
        return false
    }
    
    func isFloat() -> Bool {
        
        if let _ = Float(self) {
            return true
        }
        
        return false
    }
    
    func isDouble() -> Bool {
        let str = self.split(separator: ",").joined(separator: ["."])
        if let _ = Double(String(str)) {
            return true
        }
        
        return false
    }
}
