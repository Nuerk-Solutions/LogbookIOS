//
//  FloatingTextField.swift
//  Logbook
//
//  Created by Thomas on 02.12.21.
//

import SwiftUI

struct FloatingTextField: View {
    let title: String
    let text: Binding<String>
    
    var body: some View {
        ZStack(alignment: .leading) {
            Text(title)
                .foregroundColor(text.wrappedValue.isEmpty ? Color(.placeholderText) : .accentColor)
                .offset(y: text.wrappedValue.isEmpty ? 0 : -25)
                .scaleEffect(text.wrappedValue.isEmpty ? 1 : 0.75, anchor: .leading)
            TextField("", text: text)
        }
        .padding(.top, 15)
        .padding(.bottom, 5)
        .animation(.easeOut(duration: 0.1))
    }
}

struct FloatingTextField_Previews: PreviewProvider {
    @State private static var text = "TestContent"
    static var previews: some View {
        FloatingTextField(title: "TestTitle", text: $text)
    }
}
