//
//  Modifiers.swift
//  Logbook
//
//  Created by Thomas on 28.05.22.
//

import SwiftUI

struct OutlineModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    var cornerRadius: CGFloat = 20
    
    func body(content: Content) -> some View {
        content.overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(
                    .linearGradient(
                        colors: [
                            .white.opacity(colorScheme == .dark ? 0.1 : 0.3),
                            .black.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing)
                )
        )
    }
}

struct BackgroundStyle: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    var cornerRadius: CGFloat = 20
    var corners: UIRectCorner = [.allCorners]
    var opacity: Double = 0.6
    var lightBackground: Bool = false
    
    func body(content: Content) -> some View {
        content
            .overlay(
                Color(colorScheme == .light && lightBackground ? "Shadow": "Background")
                    .opacity(colorScheme == .light && lightBackground ? opacity : colorScheme == .dark ? opacity : 0)
                    .mask(RoundedCorner(radius: cornerRadius, corners: corners))
                    .blendMode(.overlay)
                    .allowsHitTesting(false)
            )
            .cornerRadius(cornerRadius, corners: corners)
            .overlay(
                RoundedCorner(radius: cornerRadius, corners: corners)
                    .stroke(
                        .linearGradient(
                            colors: [
                                .white.opacity(colorScheme == .dark ? 0.6 : 0.3),
                                .black.opacity(colorScheme == .dark ? 0.3 : 0.1)
                            ],
                            startPoint: .top,
                            endPoint: .bottom)
                    )
                    .blendMode(.overlay)
            )
    }
}

struct CustomTextFieldImage: ViewModifier {
    var image: Image
    var suffix: String
    func body(content: Content) -> some View {
        content
            .padding(.vertical, 10)
            .padding(.horizontal, 15)
            .padding(.leading, 36)
            .background(.secondary.opacity(0.5))
            .mask(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(lineWidth: 1).fill(.black.opacity(0.1)))
            .overlay(image.frame(maxWidth: .infinity, alignment: .leading).padding(.leading, 8))
            .overlay {
                Text(suffix)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
                    .padding(.horizontal, 20)
            }
    }
}

struct CustomTextFieldView: ViewModifier {
    var view: AnyView
    var suffix: String
    func body(content: Content) -> some View {
        content
            .padding(.vertical, 10)
            .padding(.horizontal, 15)
            .padding(.leading, 36)
            .background(.secondary)
            .mask(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(lineWidth: 1).fill(.black.opacity(0.1)))
            .overlay(view.frame(maxWidth: .infinity, alignment: .leading).padding(.leading, 8))
            .overlay {
                Text(suffix)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
                    .padding(.horizontal, 20)
            }
    }
}


struct LargeButton: ViewModifier {
    let disabled: Bool
    let shadowRadius: CGFloat
    let color: String
    
    func body(content: Content) -> some View {
        content
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(Color(hex: color).opacity(disabled ? 0.35 : 1))
            .foregroundColor(.white)
            .mask(RoundedCorner(radius: 20, corners: [.topRight, .bottomLeft, .bottomRight]))
            .mask(RoundedRectangle(cornerRadius: 8))
            .shadow(color: Color(hex: color).opacity(0.5), radius: shadowRadius, x: 0, y: 10)
        
    }
}
