//
//  AddLogbookButton.swift
//  Logbook
//
//  Created by Thomas Nürk on 15.02.24.
//

import SwiftUI

struct AddLogbookButton: View {
    
    @EnvironmentObject private var nR: NetworkReachability
    @EnvironmentObject private var model: Model
    @AppStorage("isLiteMode") private var isLiteMode: Bool = false
    
    var body: some View {
        Button {
            if(nR.reachable){
                withAnimation(.spring()) {
                    model.showAdd.toggle()
                }
            }
        } label: {
            if(nR.reachable) {
                Image(systemName: "doc.badge.plus")
                    .resizable()
                    .scaledToFit()
                    .symbolRenderingMode(.multicolor)
                    .font(.system(size: 17, weight: .bold))
                    .frame(width: 30, height: 30)
//                    .padding(10)
            } else {
                Image(systemName: "wifi.exclamationmark")
                    .resizable()
                    .scaledToFit()
                    .symbolRenderingMode(.palette)
                    .symbolEffect(.pulse.byLayer, options: .repeating)
                    .foregroundStyle(.primary, .red)
                    .frame(width: 30, height: 30)
//                    .padding(10)
            }
        }
    }
}

#Preview {
    AddLogbookButton()
        .environmentObject(NetworkReachability())
        .environmentObject(Model())
}
