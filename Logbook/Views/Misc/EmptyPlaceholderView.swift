//
//  EmptyPlaceholderView.swift
//  Logbook
//
//  Created by Thomas on 26.05.22.
//

import SwiftUI

struct EmptyPlaceholderView: View {
    
    let text: String
    let image: Image?
    
    init(text: String, image: Image? = Image(systemName: "bookmark")) {
        self.text = text
        self.image = image
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Spacer()
            if let image = self.image {
                image
                    .imageScale(.large)
                    .font(.system(size: 52))
            }
            Text(text)
            Spacer()
        }
        .onAppear(perform: dismissAllAlerts)
    }
}

struct EmptyPlaceholderView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyPlaceholderView(text: "No Entryies", image: Image(systemName: "bookmark"))
    }
}
