//
//  VoucherSelectView.swift
//  Logbook
//
//  Created by Thomas Nürk on 02.03.24.
//

import SwiftUI

struct VoucherSelectView: View {
    @Binding var usedVoucher: Bool
    @Binding var showVoucherSelectView: Bool
    @State var editMode = EditMode.active
    
    @EnvironmentObject private var voucherVM: VoucherViewModel
    
    var body: some View {
        List(voucherVM.vouchers, id: \.self, selection: $voucherVM.selectedVoucher.animation()) { voucher in
            HStack {
                Image(systemName: voucherVM.selectedVoucher == voucher ? "checkmark.circle.fill" : "circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .symbolRenderingMode(.multicolor)
                VStack(alignment: .leading, spacing: 0) {
                    Text(voucher.code)
                        .bold()
                    HStack(alignment: .firstTextBaseline) {
                        HStack {
                            Image(systemName: "person")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 10, height: 10)
                            Text(voucher.creator.rawValue + "  ·")
                        }
                        Text("\(voucher.distance) km")
                    }
                    .font(.subheadline)
                }
                Spacer()
                Text("\(voucher.remainingDistance) km")
            }
        }
        .overlay {
            if voucherVM.vouchers.isEmpty {
                VStack {
                    Text("Keine Gutscheine verfügbar")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .task(voucherVM.loadVouchers)
        .environment(\.editMode, $editMode)
        .onChange(of: voucherVM.selectedVoucher) { oldValue, newValue in
            showVoucherSelectView.toggle()
            usedVoucher = true
        }
    }
}

#Preview {
    NavigationStack {
        VoucherSelectView(usedVoucher: .constant(false), showVoucherSelectView: .constant(true))
            .environmentObject(VoucherViewModel())
    }
}
