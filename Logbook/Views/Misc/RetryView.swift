//
//  RetryView.swift
//  Logbook
//
//  Created by Thomas on 26.05.22.
//

import SwiftUI

struct RetryView: View {
    
    let text: String
    let retryAction: () -> ()
    
    var body: some View {
        VStack(spacing: 8) {
            Text(text)
                .font(.callout)
                .multilineTextAlignment(.center)
            
            Button(action: retryAction) {
                Text("Erneut versuchen")
            }
        }
        .cornerRadius(10)
        .padding(16)
        .background(.ultraThinMaterial)
        .backgroundStyle(cornerRadius: 18, opacity: 0.4)
        .onAppear(perform: dismissAllAlerts)
    }
}

struct RetryView_Previews: PreviewProvider {
    static var previews: some View {
        RetryView(text: "An error ocurred") {
            
        }
    }
}
