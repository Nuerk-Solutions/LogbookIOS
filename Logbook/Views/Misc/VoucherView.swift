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
    @State private var showAddVoucher: Bool = false
    
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
                            if !voucher.isExpired && voucher.expiration > Date() {
                                Text("Verfällt in \(voucher.expiration.toRelative(since: DateInRegion(), dateTimeStyle: .named, unitsStyle: .full))")
                            } else {
                                Text("Code Verfallen!")
                                    .foregroundStyle(.red)
                            }
                        }
                    } else {
                        Text("\(voucher.remainingDistance) km")
                    }
                }
            }
        }
        .task (voucherVM.loadVouchers)
        .refreshable(action: voucherVM.loadVouchers)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showAddVoucher.toggle()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showAddVoucher, content: {
            AddVoucherSheet(showSheet: $showAddVoucher)
                .environmentObject(voucherVM)
                .presentationBackground(.thinMaterial)
                .presentationCornerRadius(20)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        })
        .navigationTitle("Gutscheine")
    }
}

#Preview {
    NavigationStack {
        VoucherView()
            .environmentObject(VoucherViewModel())
    }
}
