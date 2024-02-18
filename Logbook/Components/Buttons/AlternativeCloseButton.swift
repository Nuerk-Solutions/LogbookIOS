//
//  AlternativeCloseButton.swift
//  Logbook
//
//  Created by Thomas Nürk on 18.02.24.
//

import SwiftUI

struct AlternativeCloseButton: View {
    
    let action: () -> Void
    @AppStorage("isLiteMode") var isLiteMode = false
    
    var body: some View {
        
        Button(action: action, label: {
            Image(systemName: "xmark")
                .foregroundColor(.white)
                .frame(width: 36, height: 36)
                .background(.black)
                .mask(Circle())
                .if(!isLiteMode, transform: { view in
                    view.shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 10)
                })
        })
        
    }
}

#Preview {
    AlternativeCloseButton {
        print("Test")
    }
}
