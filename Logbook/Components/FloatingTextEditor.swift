//
//  FloatingTextEditor.swift
//  Logbook
//
//  Created by Thomas on 18.12.21.
//

import SwiftUI

struct FloatingTextEditor: View {
    let title: String
    let text: Binding<String>
    
    var body: some View {
        ZStack(alignment: .leading) {
            Text(title)
                .foregroundColor(text.wrappedValue.isEmpty ? Color(.placeholderText) : .accentColor)
                .offset(x: 1, y: text.wrappedValue.isEmpty ? 0 : -25 - CGFloat((text.wrappedValue.numberOfLines)-1) * 15)
                .scaleEffect(text.wrappedValue.isEmpty ? 1 : 0.75, anchor: .leading)
            TextEditor(text: text)
        }
        .animation(.easeOut(duration: 0.1))
    }
}

struct FloatingTextEditor_Previews: PreviewProvider {
    @State private static var text = "TestContent"
    static var previews: some View {
        FloatingTextEditor(title: "Hellow World", text: $text)
    }
}
