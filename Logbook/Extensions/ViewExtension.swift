//
//  ViewExtension.swift
//  Logbook
//
//  Created by Thomas on 06.05.22.
//

import Foundation
import SwiftUI

extension View {
    func dismissToRoot() {
        let rootViewController = UIApplication.shared.connectedScenes
            .filter {$0.activationState == .foregroundActive }
            .map {$0 as? UIWindowScene }
            .compactMap { $0 }
            .first?.windows
            .filter({ $0.isKeyWindow }).first?.rootViewController
        
        rootViewController?.dismiss(animated: true)
    }
}
