//
//  AddVoucherSheet.swift
//  Logbook
//
//  Created by Thomas Nürk on 01.03.24.
//

import SwiftUI

struct AddVoucherSheet: View {
    @State private var date: Date = Date()
    @AppStorage("currentDriver") private var currentDriver: DriverEnum = .Andrea
    @State private var creator: DriverEnum = .Andrea
    @State private var value: Int = 5
    
    @State private var showPicker: Bool = false
    @Binding var showSheet: Bool
    
    @EnvironmentObject var voucherVM: VoucherViewModel
    
    init(showSheet: Binding<Bool>) {
        UITableView.appearance().backgroundColor = UIColor.clear
        self._showSheet = showSheet
    }
    
    var body: some View {
        Form {
            Picker("Ersteller", selection: $creator.animation()) {
                ForEach(DriverEnum.allCases) { driver in
                    Text(driver.rawValue)
                        .tag(driver)
                }
            }
            Button {
                withAnimation {
                    showPicker.toggle()
                }
            } label: {
                HStack {
                    Text("Wert")
                    Spacer()
                    Text("\(value) €")
                        .foregroundStyle(.gray)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            
            if showPicker {
                Picker("Wert", systemImage: "eurosign", selection: $value) {
                    ForEach(1...100, id: \.self) { number in
                        Text("\(number)")
                    }
                }
                .pickerStyle(.wheel)
            }
            DatePicker("Einlösbar bis", selection: $date, in: Date()..., displayedComponents: .date)
            
            Section {
                VStack {
                    Button {
                        Task {
                            showSpinningAlert()
                            let result = await voucherVM.createVoucher(voucher: Voucher(code: "", value: value, expiration: date, creator: creator))
                            if result {
                                dismissAllAlerts()
                                showSheet.toggle()
                                showSuccessfulAlert(title: "Gutschein erstellt")
                                await voucherVM.loadVouchers()
                            } else {
                                dismissAllAlerts()
                                showFailureAlert()
                            }
                        }
                    } label: {
                        Text("Gutschein erstellen")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .largeButton(disabled: false, shadowRadius: 10)
                    VStack {}
                        .padding(.bottom, 20)
                }
            }
            .listRowBackground(Color.clear)
        }
        .task {
            creator = currentDriver
        }
    }
}

#Preview {
    AddVoucherSheet(showSheet: .constant(true))
}
