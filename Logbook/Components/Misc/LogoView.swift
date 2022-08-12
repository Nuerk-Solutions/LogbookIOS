//
//  LogoView.swift
//  Logbook
//
//  Created by Thomas on 07.06.22.
//

import SwiftUI

struct LogoView: View {
    var image = "Logo Ferrari"
    
    var body: some View {
        Image(image)
            .resizable()
            .frame(width: 26, height: 26)
            .cornerRadius(10)
            .padding(8)
            .background(.ultraThinMaterial)
            .backgroundStyle(cornerRadius: 18, opacity: 0.4)
    }
}

struct LogoView_Previews: PreviewProvider {
    static var previews: some View {
        LogoView()
    }
}
