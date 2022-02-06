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
    @State private var scaleEffect: CGFloat = 1
    @State private var offset: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Text(title)
                .foregroundColor(text.wrappedValue.isEmpty ? Color(.placeholderText) : .accentColor)
                .offset(x: 1, y: offset)
                .scaleEffect(scaleEffect, anchor: .leading)
            
            
            TextEditor(text: text)
                .padding(.horizontal, -4)
                .padding(.vertical, 3)
                .multilineTextAlignment(.leading)
                .frame(minHeight: 30, alignment: .leading)
            
        }
        .padding(.top, 15)
        .onChange(of: text.wrappedValue.isEmpty) { newValue in
            withAnimation (.easeOut(duration: 0.1)){
                scaleEffect = text.wrappedValue.isEmpty ? 1 : 0.75
                offset = text.wrappedValue.isEmpty ? 0 : -25
            }
        }
        .onAppear {
            withAnimation (.easeOut(duration: 0.1)){
                scaleEffect = text.wrappedValue.isEmpty ? 1 : 0.75
                offset = text.wrappedValue.isEmpty ? 0 : -20
            }
        }
    }
}

struct FloatingTextEditor_Previews: PreviewProvider {
    @State private static var text = "TestContent"
    static var previews: some View {
        VStack {
            Spacer()
            FloatingTextEditor(title: "Hellow World", text: $text)
        }
    }
}
