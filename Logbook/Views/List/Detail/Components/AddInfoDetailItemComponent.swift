//
//  AddInfoRowComponent.swift
//  Logbook
//
//  Created by Thomas Nürk on 05.03.24.
//

import SwiftUI

struct AddInfoDetailItemComponent: View {
    
    var imageIconName: String
    var title: String
    var subTitle: String
    var offSet: Double
    
    var body: some View {
        CircularIconProgressContainer(imageIconName: imageIconName, circleValue: 1, progressValue: 0) {
            Text(title)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.secondary)
            Text(subTitle)
                .fontWeight(.semibold)
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .backgroundStyle(cornerRadius: 30)
        .padding(20)
        .padding(.top, -offSet)
    }
}

#Preview {
    AddInfoDetailItemComponent(imageIconName: "wrench.and.screwdriver", title: "Informationstyp", subTitle: "Wartung", offSet: 60)
}
