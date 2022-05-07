//
//  InvoiceCreateView.swift
//  Logbook
//
//  Created by Thomas on 23.04.22.
//

import SwiftUI
import SPAlert

struct InvoiceCreateView: View {
    
    @State private var invoiceDate: Date = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
    @State private var showSheet: Bool = false
    
    @State var driver: [DriverEnum] = DriverEnum.allCases
    @State var selectedDrivers: [DriverEnum] = [DriverEnum.Andrea, DriverEnum.Thomas]
    
    @EnvironmentObject var invoiceViewModel: InvoiceViewModel
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "de_DE")
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    DatePicker("Abrechnung zum", selection: $invoiceDate, in: datePickerRange(), displayedComponents: .date)
                        .environment(\.locale, Locale.init(identifier: "de_DE"))
                    Button {
                        withAnimation {
                            showSheet.toggle()
                        }
                    } label: {
                        Text("Abrechnung erstellen")
                    }
                    .disabled(invoiceDate == Date())
                } footer: {
                    Text("Es wird eine Abrechnung für den Zeitraum von \(dateFormatter.string(from: invoiceViewModel.latestInvoiceDate)) bis inklusive \(dateFormatter.string(from: invoiceDate)) erstellt. Wenn der Knopf einmal betätigt wurde, kann die Abrechnung nicht mehr abgebrochen werden.")
                }
                
                DisclosureGroup {
                    ForEach(invoiceViewModel.invoiceHistory, id: \.date) { (item) in
                        Text("\(dateFormatter.string(from: item.date) == "23.11.2021" ? ("\(dateFormatter.string(from: item.date)) (Initaldatum)") : (dateFormatter.string(from: item.date)))")
                    }
                } label: {
                    Text("Historie")
                }
            }
            .navigationTitle("Abrechnung erstellen")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismissToRoot()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30, alignment: .center)
                    }
                }
            })
        }
        .onAppear {
            invoiceViewModel.fetchInvoiceHistory()
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
                                    }
                                    else {
                                        self.selectedDrivers.append(item)
                                    }
                                }
                            }
                        }
                    }
                    
                    Button {
                        invoiceViewModel.createInvoice(drivers: selectedDrivers, endDate: invoiceDate)
                        dismissToRoot()
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
    
    func datePickerRange() -> ClosedRange<Date> {
        let startDate = Calendar.current.date(byAdding: .day, value: 1, to: invoiceViewModel.latestInvoiceDate)!
        let endDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        
        if (endDate < startDate) {
            return Date()...Date()
        }
        return startDate...endDate
    }
}

struct InvoiceCreateView_Previews: PreviewProvider {
    static var previews: some View {
        InvoiceCreateView(driver: DriverEnum.allCases)
            .environmentObject(InvoiceViewModel())
    }
}
