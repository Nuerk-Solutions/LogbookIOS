//
//  AdditionalInfoImageView.swift
//  Logbook
//
//  Created by Thomas on 14.06.22.
//

import SwiftUI

struct AdditionalInfoImageView: View {
    
    let informationTyp: AdditionalInformationTypEnum
    
    var body: some View {
        switch informationTyp {
        case .Keine:
            EmptyView()
        case .Getankt:
            Image(systemName: "fuelpump.fill")
                .symbolRenderingMode(.hierarchical)
                .resizable()
                .padding(5)
                .background(.ultraThickMaterial)
                .frame(width: 26, height: 26)
                .cornerRadius(10)
                .padding(8)
                .background(.ultraThinMaterial)
                .backgroundStyle(cornerRadius: 18, opacity: 0.4)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(20)
//                .matchedGeometryEffect(id: "logo\(entry.id)", in: namespace)
        case .Gewartet:
            Image(systemName: "wrench.and.screwdriver")
                .symbolRenderingMode(.hierarchical)
                .resizable()
                .padding(5)
                .background(.ultraThickMaterial)
                .frame(width: 26, height: 26)
                .cornerRadius(10)
                .padding(8)
                .background(.ultraThinMaterial)
                .backgroundStyle(cornerRadius: 18, opacity: 0.4)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(20)
//                .matchedGeometryEffect(id: "logo\(entry.id)", in: namespace)
        }
    }
}

struct AdditionalInfoImageView_Previews: PreviewProvider {
    static var previews: some View {
        AdditionalInfoImageView(informationTyp: .Getankt)
    }
}
