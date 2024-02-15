//
//  UiHelper.swift
//  Logbook
//
//  Created by Thomas Nürk on 15.02.24.
//

import Foundation
import SwiftUI

extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

//    /// Applies the given transform if the given condition evaluates to `true`.
//    /// - Parameters:
//    ///   - condition: The condition to evaluate.
//    ///   - transform: The transform to apply to the source `View`.
//    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
//    @ViewBuilder func `if`<Content: View>(_ condition: @autoclosure () -> Bool, transform: (Self) -> Content) -> some View {
//        if condition() {
//            transform(self)
//        } else {
//            self
//        }
//    }
}

extension Bool {
    // TODO: IMPL OLD CHECK:
//    UIDevice.current.model
     static var oldGeneration: Bool {
         guard #available(iOS 14, *) else {
             // It's iOS 13 so return true.
             return true
         }
         // It's iOS 14 so return false.
         return false
     }
 }
