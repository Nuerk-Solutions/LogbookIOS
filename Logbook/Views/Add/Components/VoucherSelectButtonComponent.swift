//
//  VoucherSelectView.swift
//  Logbook
//
//  Created by Thomas Nürk on 01.03.24.
//

import SwiftUI

struct VoucherSelectButtonComponent: View {
    
    @State private var showVoucherSelectView: Bool = false
    @State private var usedVoucher: Bool = false
    
    var body: some View {
        HStack {
            Button {
                withAnimation {
                    if(usedVoucher) {
                        usedVoucher.toggle()
                    } else {
                        showVoucherSelectView.toggle()
                    }
                }
            } label: {
                Image(systemName: usedVoucher ? "gift.fill": "gift")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 26, height: 26)
                    .symbolRenderingMode(.palette)
                    .foregroundColor(usedVoucher ? .green : .primary)
                    .padding(8)
                    .background(.ultraThinMaterial)
                    .backgroundStyle(cornerRadius: 18, opacity: 0.4)
            }.buttonStyle(PlainButtonStyle())
        }
        .sheet(isPresented: $showVoucherSelectView, content: {
            VoucherSelectView(usedVoucher: $usedVoucher, showVoucherSelectView: $showVoucherSelectView)
                .presentationDetents([.medium])
        })
    }
}

#Preview {
    VoucherSelectButtonComponent()
}
