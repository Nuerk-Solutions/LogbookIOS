//
//  CustomProgressView.swift
//  Logbook
//
//  Created by Thomas on 26.02.22.
//

import SwiftUI

struct CustomProgressView: View {
    let message: String
    
    var body: some View {
        ZStack {
            Color(.systemBackground).opacity(0.4)
                .ignoresSafeArea()
                .blur(radius: 5)
            
            ProgressView(message)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemBackground)))
        }
        .shadow(radius: 10)
    }
}

struct CustomProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CustomProgressView(message: "Saving File")
    }
}
