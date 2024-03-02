//
//  VoucherViewModel.swift
//  Logbook
//
//  Created by Thomas Nürk on 29.02.24.
//

import Foundation
import SwiftUI

@MainActor
class VoucherViewModel: ObservableObject {
    
    @Published var vouchers: [Voucher] = Voucher.previewData
    private let logbookAPI = LogbookAPI.shared
    
    @Sendable
    func loadVouchers() async {
        if Task.isCancelled { return }
        
        do {
            let result = try await logbookAPI.fetchVouchers()

            withAnimation {
                vouchers = result
            }
        } catch {
            print(error)
            if Task.isCancelled { return }
        }
    }
    
    func redeemVoucher(voucher: Voucher) async -> Bool {
        if Task.isCancelled { return false }
        do {
            return try await logbookAPI.redeemVoucher(voucher: voucher)
        } catch {
            print(error)
            if Task.isCancelled { return false }
        }
        return false
    }
    
    func createVoucher(voucher: Voucher) async -> Bool {
        if Task.isCancelled { return false }
        do {
            let response = try await logbookAPI.createVoucher(voucher: voucher)
            print(response.expiration, voucher.expiration)
            return response.creator == voucher.creator && response.value == voucher.value
        } catch {
            print(error)
            if Task.isCancelled { return false }
        }
        return false
    }
    
}
