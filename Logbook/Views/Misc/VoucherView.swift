//
//  VoucherView.swift
//  Logbook
//
//  Created by Thomas Nürk on 29.02.24.
//

import SwiftUI
import SwiftDate

struct VoucherView: View {
    @StateObject private var voucherVM: VoucherViewModel = VoucherViewModel()
    var body: some View {
            List {
                ForEach(voucherVM.vouchers, id: \._id) { voucher in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(voucher.code)
                                .font(.subheadline)
                                .bold()
                            Text("Erstellt von \(voucher.creator.rawValue)")
                                .font(.caption)
                                .padding(.trailing, 20)
                        }
                        Spacer()
                            if voucher.redeemed {
                                VStack {
                                    if !voucher.isExpired {
                                        Text("Verfällt in \(voucher.expiration.toRelative(since: DateInRegion(), dateTimeStyle: .named, unitsStyle: .full))")
                                    } else {
                                        Text("Code Verfallen!")
                                    }
                                }
                                .if(voucher.isExpired) { view in
                                    view.foregroundStyle(.red)
                                }
                            } else {
                                Text("\(voucher.remainingDistance) km")
                            }
                    }
                }
            }
            .task (voucherVM.loadVouchers)
            .refreshable(action: voucherVM.loadVouchers)
            .navigationTitle("Gutscheine")
    }
}

#Preview {
    VoucherView()
}
