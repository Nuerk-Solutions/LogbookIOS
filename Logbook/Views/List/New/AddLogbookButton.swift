//
//  AddLogbookButton.swift
//  Logbook
//
//  Created by Thomas Nürk on 15.02.24.
//

import SwiftUI

struct AddLogbookButton: View {
    
    @EnvironmentObject private var networkReachablility: NetworkReachability
    @EnvironmentObject private var model: Model
    @AppStorage("isLiteMode") private var isLiteMode: Bool = false
    
    var body: some View {
        Button {
            if((NetworkReachability.shared.reachabilityManager?.isReachable) != nil){
                withAnimation(.spring()) {
                    model.showAdd.toggle()
                }
            }
        } label: {
            if((NetworkReachability.shared.reachabilityManager?.isReachable) != nil) {
                Image(systemName: "doc.badge.plus")
                    .resizable()
                    .scaledToFit()
                    .symbolRenderingMode(.multicolor)
                    .font(.system(size: 17, weight: .bold))
                    .frame(width: 20, height: 20)
                    .foregroundColor(.secondary)
                    .padding(10)
                    .background(.regularMaterial)
                    .backgroundStyle(cornerRadius: 16, opacity: 0.4)
                    .if(!isLiteMode, transform: { view in
                        view.shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 10)
                    })
            } else {
                Image(systemName: "wifi.exclamationmark")
                    .resizable()
                    .scaledToFit()
                    .symbolRenderingMode(.palette)
                    .symbolEffect(.pulse.byLayer, options: .repeating)
                    .foregroundStyle(.primary, .red)
                    .frame(width: 20, height: 20)
                    .padding(10)
                    .background(.regularMaterial)
                    .backgroundStyle(cornerRadius: 16, opacity: 0.4)
                    .if(!isLiteMode, transform: { view in
                            view.shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 10)
                    })
            }
        }
    }
}

#Preview {
    AddLogbookButton()
}
