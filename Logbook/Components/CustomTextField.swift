//
//  CustomTextField.swift
//  Logbook
//
//  Created by Thomas on 27.05.22.
//

import SwiftUI

struct CustomTextFieldImage: ViewModifier {
    var image: Image
    var suffix: String
    func body(content: Content) -> some View {
        content
            .padding(.vertical, 10)
            .padding(.horizontal, 15)
            .padding(.leading, 36)
            .background(.secondary)
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

extension View {
    func customTextField(image: Image, suffix: String = "") -> some View {
        modifier(CustomTextFieldImage(image: image, suffix: suffix))
    }
    func customTextField<Content:View>(@ViewBuilder view: ()-> Content, suffix: String = "") -> some View {
        modifier(CustomTextFieldView(view: AnyView(view()), suffix: suffix))
    }
}
