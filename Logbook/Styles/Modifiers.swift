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

struct OutlineVerticalModifier: ViewModifier {
    var cornerRadius: CGFloat = 20
    
    func body(content: Content) -> some View {
        content.overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(
                    .linearGradient(
                        colors: [.black.opacity(0.2), .white.opacity(0.6)],
                        startPoint: .top,
                        endPoint: .bottom)
                )
                .blendMode(.overlay)
        )
    }
}

struct SlideFadeIn: ViewModifier {
    var show: Bool
    var offset: Double
    
    func body(content: Content) -> some View {
        content
            .opacity(show ? 1 : 0)
            .offset(y: show ? 0 : offset)
    }
}

extension View {
    func slideFadeIn(show: Bool, offset: Double = 10) -> some View {
        self.modifier(SlideFadeIn(show: show, offset: offset))
    }
}

extension View {
    func backgroundStyle(cornerRadius: CGFloat = 20, corners: UIRectCorner = [.allCorners], opacity: Double = 0.6, lightBackground: Bool = false) -> some View {
        self.modifier(BackgroundStyle(cornerRadius: cornerRadius, corners: corners, opacity: opacity, lightBackground: lightBackground))
    }
    
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
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


struct CentreAlignedLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        Label {
            configuration.title
                .alignmentGuide(.firstTextBaseline) {
                    $0[VerticalAlignment.center]
                }
        } icon: {
            configuration.icon
                .alignmentGuide(.firstTextBaseline) {
                    $0[VerticalAlignment.center]
                }
        }
    }
}
