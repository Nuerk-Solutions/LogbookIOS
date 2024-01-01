//
//  CustomTextArea.swift
//  Logbook
//
//  Created by Thomas on 01.08.22.
//

import Foundation
import SwiftUI

struct CustomTextArea: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .padding(.vertical, 10)
            .padding(.horizontal, 15)
            .background(.secondary.opacity(0.5))
            .mask(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(lineWidth: 1).fill(.black.opacity(0.1)))
    }
    
}


extension View {
    func customTextArea() -> some View {
        modifier(CustomTextArea())
    }
    /// Layers the given views behind this ``TextEditor``.
        func textEditorBackground<V>(@ViewBuilder _ content: () -> V) -> some View where V : View {
            self
                .onAppear {
                    UITextView.appearance().backgroundColor = .clear
                }
                .background(content())
        }
}
