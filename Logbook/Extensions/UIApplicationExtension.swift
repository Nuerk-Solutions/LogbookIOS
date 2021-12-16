//
//  UIApplicationExtension.swift
//  Logbook
//
//  Created by Thomas on 16.12.21.
//

import Foundation

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
