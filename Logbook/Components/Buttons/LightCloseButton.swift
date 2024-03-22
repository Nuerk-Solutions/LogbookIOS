//
//  CloseButton.swift
//  Logbook
//
//  Created by Thomas on 28.05.22.
//

import SwiftUI

struct LightCloseButton: View {
    var body: some View {
        Image(systemName: "xmark")
            .font(.system(size: 17, weight: .bold))
            .foregroundColor(.secondary)
            .padding(8)
            .background(.ultraThinMaterial, in: Circle())
            .backgroundStyle(cornerRadius: 18)
    }
}

struct CloseButton_Previews: PreviewProvider {
    static var previews: some View {
        LightCloseButton()
    }
}
