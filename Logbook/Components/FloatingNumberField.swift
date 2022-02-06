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
    
    @State private var scaleEffect: CGFloat = 1
    @State private var offset: CGFloat = 0
    
    var body: some View {
        let isEmpty = String(text.wrappedValue).isEmpty || text.wrappedValue == -1
        ZStack(alignment: .leading) {
            Text(title)
                .foregroundColor(isEmpty ? Color(.placeholderText) : .accentColor)
                .offset(y: offset)
                .scaleEffect(scaleEffect, anchor: .leading)
            TextField("", value: text, formatter: NumberFormatter())
        }
        .padding(.top, 15)
        .padding(.bottom, 5)
        .onChange(of: text.wrappedValue) { newValue in
            withAnimation(.easeOut(duration: 0.1)) {
                scaleEffect = isEmpty ? 1 : 0.75
                offset = isEmpty ? 0 : -25
            }
        }
        .onAppear(perform: {
            withAnimation(.easeOut(duration: 0.1)) {
                scaleEffect = isEmpty ? 1 : 0.75
                offset = isEmpty ? 0 : -25
            }
        })
    }
}

struct FloatingNumberField_Previews: PreviewProvider {
    @State private static var text = "TestContent"
    static var previews: some View {
        FloatingTextField(title: "TestTitle", text: $text)
    }
}
