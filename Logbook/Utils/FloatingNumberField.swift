//
//  FloatingTextField.swift
//  Logbook
//
//  Created by Thomas on 08.12.21.
//

import SwiftUI

struct FloatingNumberField: View {
    let title: String
    let text: Binding<Int>
    
    var body: some View {
        ZStack(alignment: .leading) {
            let isEmpty = String(text.wrappedValue).isEmpty
            Text(title)
                .foregroundColor(isEmpty ? Color(.placeholderText) : .accentColor)
                .offset(y: isEmpty ? 0 : -25)
                .scaleEffect(isEmpty ? 1 : 0.75, anchor: .leading)
            TextField("", value: text, formatter: NumberFormatter())
        }
        .padding(.top, 15)
        .padding(.bottom, 5)
        .animation(.easeOut(duration: 0.1))
    }
}

struct FloatingNumberField_Previews: PreviewProvider {
    @State private static var text = "TestContent"
    static var previews: some View {
        FloatingTextField(title: "TestTitle", text: $text)
    }
}
