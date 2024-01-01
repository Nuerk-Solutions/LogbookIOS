//
//  AdditionalInfoImageView.swift
//  Logbook
//
//  Created by Thomas on 14.06.22.
//

import SwiftUI

struct AdditionalInfoImageView: View {
    
    let logbook: LogbookEntry
    
    var body: some View {
        if(logbook.refuel != nil) {
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
        } else if(logbook.service != nil) {
                Image(systemName: "wrench.and.screwdriver")
    //                .symbolRenderingMode(.hierarchical)
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
        AdditionalInfoImageView(logbook: LogbookEntry())
    }
}
