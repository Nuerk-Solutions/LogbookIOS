//
//  View+Extension.swift
//  Logbook
//
//  Created by Thomas Nürk on 05.03.24.
//

import SwiftUI


extension View {
    
    // MARK: - CustomTextField
    func customTextField(image: Image, suffix: String = "") -> some View {
        modifier(CustomTextFieldImage(image: image, suffix: suffix))
    }
    func customTextField<Content:View>(@ViewBuilder view: ()-> Content, suffix: String = "") -> some View {
        modifier(CustomTextFieldView(view: AnyView(view()), suffix: suffix))
    }
    
    //MARK: - LargeButton
    func largeButton(disabled: Bool = false, shadowRadius radius: CGFloat = 20, color: String = "F77D8E") -> some View {
        modifier(LargeButton(disabled: disabled, shadowRadius: radius, color: color))
    }

    
    //MARK: - BackgroundStyle
    func backgroundStyle(cornerRadius: CGFloat = 20, corners: UIRectCorner = [.allCorners], opacity: Double = 0.6, lightBackground: Bool = false) -> some View {
        self.modifier(BackgroundStyle(cornerRadius: cornerRadius, corners: corners, opacity: opacity, lightBackground: lightBackground))
    }
    
    //MARK: - RoundedCorner
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
    //MARK: - Conditional view modifier appliement
    
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
    
    //MARK: - Hide Keyboard
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
