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
    
    @State private var scaleEffect: CGFloat = 1
    @State private var offset: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .leading) {
            Text(title)
                .foregroundColor(text.wrappedValue.isEmpty ? Color(.placeholderText) : .accentColor)
                .offset(y: offset)
                .scaleEffect(scaleEffect, anchor: .leading)
            TextField("", text: text).ignoresSafeArea(.all, edges: .all)
        }
        .padding(.top, 15)
        .padding(.bottom, 5)
        .onChange(of: text.wrappedValue) { newValue in
            withAnimation(.easeOut(duration: 0.1)) {
                scaleEffect = text.wrappedValue.isEmpty ? 1 : 0.75
                offset = text.wrappedValue.isEmpty ? 0 : -25
            }
        }
        .onAppear(perform: {
            withAnimation(.easeOut(duration: 0.1)) {
                scaleEffect = text.wrappedValue.isEmpty ? 1 : 0.75
                offset = text.wrappedValue.isEmpty ? 0 : -25
            }
        })
        .ignoresSafeArea(.all, edges: .all)
    }
}

struct FloatingTextField_Previews: PreviewProvider {
    @State private static var text = "TestContent"
    static var previews: some View {
        FloatingTextField(title: "TestTitle", text: $text)
    }
}
