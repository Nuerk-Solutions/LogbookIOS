//
//  InvoiceCreateView.swift
//  Logbook
//
//  Created by Thomas on 23.04.22.
//

import SwiftUI
import SPAlert

struct InvoiceCreateView: View {
    
    @State private var invoiceDate: Date = Date()
    @State private var showSheet: Bool = false
    
    @State var driver: [DriverEnum] = DriverEnum.allCases
    @State var selectedDrivers: [DriverEnum] = [DriverEnum.Andrea, DriverEnum.Thomas]
    
    @EnvironmentObject var invoiceViewModel: InvoiceViewModel
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "de_DE")
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    DatePicker("Abrechnung zum", selection: $invoiceDate, displayedComponents: .date)
                        .environment(\.locale, Locale.init(identifier: "de_DE"))
                    Button {
                        withAnimation {
                            showSheet.toggle()
                        }
                    } label: {
                        Text("Abrechnung erstellen")
                    }
                } footer: {
                    Text("Es wird eine Abrechnung für den Zeitraum von DATE1 bis inklusive \(dateFormatter.string(from: invoiceDate)) erstellt")
                }
                
                DisclosureGroup {
                    Text("TEST")
                } label: {
                    Text("Historie")
                }
            }
            .navigationTitle("Abrechnung erstellen")
        }
        .sheet(isPresented: $showSheet) {
            NavigationView {
                List {
                    Section {
                        ForEach(self.driver, id: \.self) { item in
                            HStack {
                                ExportSelectionRowView(title: item.id, isSelected: self.selectedDrivers.contains(item)) {
                                    if self.selectedDrivers.contains(item) {
                                        self.selectedDrivers.removeAll(where: { $0 == item })
                                        print("Remove")
                                    }
                                    else {
                                        self.selectedDrivers.append(item)
                                    }
                                }
                            }
                        }
                    }
                    
                    Button {
                        let rootViewController = UIApplication.shared.connectedScenes
                            .filter {$0.activationState == .foregroundActive }
                            .map {$0 as? UIWindowScene }
                            .compactMap { $0 }
                            .first?.windows
                            .filter({ $0.isKeyWindow }).first?.rootViewController
                        
                        rootViewController?.dismiss(animated: true) {
                            SPAlertView(title: "Neue Abrechnung erstellt", message: "", preset: .done).present(haptic: .success) {
                                Task {
                                    await invoiceViewModel.createInvoice(drivers: selectedDrivers, endDate: invoiceDate)
                                }
                            }
                        }
                    } label: {
                        Text("Erstellen & Versenden")
                            .frame(maxWidth: .infinity)
                    }
                    
                }
                .navigationTitle("Email Info an")
            }
            .interactiveDismissDisabled()
        }
    }
}

struct InvoiceCreateView_Previews: PreviewProvider {
    static var previews: some View {
        InvoiceCreateView(driver: DriverEnum.allCases)
            .environmentObject(InvoiceViewModel())
    }
}
