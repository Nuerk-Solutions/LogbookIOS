//
//  ProgressView.swift
//  Logbook
//
//  Created by Thomas on 26.05.22.
//

import SwiftUI

struct CustomProgressView: View {
    
    let message: String
    
    var body: some View {
        ZStack {
            ProgressView(message)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemBackground)))
        }
        .shadow(radius: 10)
    }
}

struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CustomProgressView(message: "Loading...")
    }
}
