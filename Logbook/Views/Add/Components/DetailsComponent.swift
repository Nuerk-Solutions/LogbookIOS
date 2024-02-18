//
//  DetailsView.swift
//  Logbook
//
//  Created by Thomas Nürk on 01.01.24.
//

import SwiftUI

struct DetailsComponent: View {
    
    @Binding var newLogbook: LogbookEntry
    
    var body: some View {
        HStack {
            Image(systemName: newLogbook.details.covered ? "checkmark.square.fill" : "x.square.fill")
                .resizable()
                .frame(width: 26, height: 26)
                .cornerRadius(10)
                .padding(8)
                .background(.ultraThinMaterial)
                .backgroundStyle(cornerRadius: 18, opacity: 0.4)
                .foregroundColor(newLogbook.details.covered ? .green : .red)
            
            Text(newLogbook.details.covered ? "Die Fahrt wird übernommen" : "Die Fahrt wird nicht übernommen.")
                .font(.footnote.weight(.medium))
                .padding(5)
            //                    .foregroundStyle(.secondary)
                .background(.secondary.opacity(0.4))
                .mask(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(lineWidth: 1).fill(.black.opacity(0.1)))
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                newLogbook.details.covered.toggle()
            }
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    DetailsComponent(newLogbook: .constant(LogbookEntry.previewData.data[0]))
}
