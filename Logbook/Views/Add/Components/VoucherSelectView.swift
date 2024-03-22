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
    @State private var selection: Voucher?
    
    @EnvironmentObject private var voucherVM: VoucherViewModel
    
    var body: some View {
        List(voucherVM.vouchers, id: \.self, selection: $selection.animation()) { voucher in
            HStack {
                Image(systemName: selection == voucher ? "checkmark.circle.fill" : "circle")
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
        .task(voucherVM.loadVouchers)
        .environment(\.editMode, $editMode)
        .onChange(of: selection) { oldValue, newValue in
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
