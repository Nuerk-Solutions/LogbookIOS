//
//  AddInfoButtonComponent.swift
//  Logbook
//
//  Created by Thomas Nürk on 01.01.24.
//

import SwiftUI

struct AddInfoButtonComponent: View {
    @Binding var newLogbook: LogbookEntry
    @Binding var showAddInfoSlection: Bool
    
    var body: some View {
        HStack {
            Button {
                withAnimation {
                    showAddInfoSlection.toggle()
                }
            } label: {
                Image(systemName: !newLogbook.hasAddInfo ? "paperclip" : newLogbook.service != nil ? "wrench.and.screwdriver" : "fuelpump")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 26, height: 26)
                    .symbolRenderingMode(.palette)
                    .foregroundColor(.primary)
                    .padding(8)
                    .background(.ultraThinMaterial)
                    .backgroundStyle(cornerRadius: 18, opacity: 0.4)
                
                
//                if !newLogbook.hasAddInfo {
//                    Text("Weitere Daten speichern")
//                        .font(.footnote.weight(.medium))
//                        .padding(6)
//                        .background(.secondary)
//                        .mask(RoundedRectangle(cornerRadius: 10, style: .continuous))
//                        .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(lineWidth: 1).fill(.black.opacity(0.1)))
//                        .fixedSize(horizontal: false, vertical: true)
//                } else {
//                    HStack {
//                        Text("Datenübersicht")
//                            .font(.footnote.weight(.medium))
//                    }
//                    .lineLimit(2)
//                    .padding(6)
//                    .background(.secondary)
//                    .mask(RoundedRectangle(cornerRadius: 10, style: .continuous))
//                    .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(lineWidth: 1).fill(.black.opacity(0.1)))
//                }
            }.buttonStyle(PlainButtonStyle())
        }
    }
}

#Preview {
    AddInfoButtonComponent(newLogbook: .constant(LogbookEntry.previewData.data[0]), showAddInfoSlection: .constant(false))
}
