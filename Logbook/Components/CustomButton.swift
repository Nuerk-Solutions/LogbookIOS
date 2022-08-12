//
//  CustomButton.swift
//  Logbook
//
//  Created by Thomas on 27.05.22.
//

import SwiftUI
 
struct CustomButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(16)
            .padding(.horizontal, 8)
            .background(.white)
            .mask(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .foregroundStyle(.primary)
            .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
    }
}

extension View {
    func customButton() -> some View {
        modifier(CustomButton())
    }
}

struct LargeButton: ViewModifier {
    let disabled: Bool
    func body(content: Content) -> some View {
        content
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(Color(hex: "F77D8E").opacity(disabled ? 0.35 : 1))
            .foregroundColor(.white)
            .mask(RoundedCorner(radius: 20, corners: [.topRight, .bottomLeft, .bottomRight]))
            .mask(RoundedRectangle(cornerRadius: 8))
            .shadow(color: Color(hex: "F77D8E").opacity(0.5), radius: 20, x: 0, y: 10)
    }
}

extension View {
    func largeButton(disabled: Bool = false) -> some View {
        modifier(LargeButton(disabled: disabled))
    }
}
