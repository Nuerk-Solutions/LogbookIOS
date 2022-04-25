//
//  InvoiceView.swift
//  Logbook
//
//  Created by Thomas on 22.04.22.
//

import SwiftUI

struct InvoiceView: View {
    
    @StateObject private var invoiceViewModel: InvoiceViewModel = InvoiceViewModel()
    
    @State private var startDate: Date = DateFormatter.yearMonthDay.date(from: "2021-11-23")!
    @State private var endDate: Date = Date()
    
    @State private var showSheet: Bool = false
    @State private var firstFetch: Bool = true
    @State private var isVehicle: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                ScrollView(.horizontal, showsIndicators: true) {
                    HStack {
                        DatePicker("Von", selection: $startDate, in: DateFormatter.yearMonthDay.date(from: "2021-11-23")!...endDate, displayedComponents: .date)
                            .environment(\.locale, Locale.init(identifier: "de_DE"))
                        DatePicker("Bis", selection: $endDate, in: startDate...Date(), displayedComponents: .date)
                            .environment(\.locale, Locale.init(identifier: "de_DE"))
                            .padding(.horizontal, 15)
                    }
                    .padding()
                }
                if isVehicle {
                    InvoiceVehicleOverview()
                        .environmentObject(invoiceViewModel)
                } else {
                    InvoiceDriverOverview()
                        .environmentObject(invoiceViewModel)
                }
            }
            .background {
                AnimatedBackground()
                    .edgesIgnoringSafeArea(.all)
                    .blur(radius: 50)
                    .opacity(0.5)
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    if invoiceViewModel.isLoading {
                        ProgressView()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Button {
                        withAnimation {
                            showSheet.toggle()
                        }
                    } label: {
                        Image(systemName: "books.vertical.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        withAnimation {
                            isVehicle.toggle()
                            fetchLatestStats()
                        }
                    } label: {
                        Image(systemName: !isVehicle ? "car.circle" : "person.2.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                }
            }
            .sheet(isPresented: $showSheet, content: {
                InvoiceCreateView()
                    .environmentObject(invoiceViewModel)
            })
            .navigationTitle("Statisitk")
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            await invoiceViewModel.fetchInvoiceHistory()
        }
        .onChange(of: startDate) { newValue in
            fetchLatestStats()
        }
        .onChange(of: endDate) { newValue in
            fetchLatestStats()
        }
        .onChange(of: invoiceViewModel.latestInvoiceDate) { newValue in
            startDate = newValue
            if firstFetch {
                Task {
                    firstFetch = false
                    await invoiceViewModel.fetchDriverStats(drivers: DriverEnum.allCases, vehicles: VehicleEnum.allCases, startDate: startDate, endDate: endDate, detailed: true)
                }
            }
        }
    }
    
    func fetchLatestStats() {
        if isVehicle {
            Task {
                await invoiceViewModel.fetchVehicleStats(vehicles: VehicleEnum.allCases, startDate: startDate, endDate: endDate)
            }
        } else {
            Task {
                await invoiceViewModel.fetchDriverStats(drivers: DriverEnum.allCases, vehicles: VehicleEnum.allCases, startDate: startDate, endDate: endDate, detailed: true)
            }
        }
    }
}

struct AnimatedBackground: View {
    @State var start: UnitPoint = .top
    @State var end: UnitPoint = .bottom
    @Environment(\.colorScheme) var colorScheme
    
    let timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    
    var body: some View {
        
        LinearGradient(gradient: Gradient(colors:  [colorScheme == .dark ? Color.black : Color.white, Color.red, Color.purple, Color.blue, Color.indigo, Color.orange, colorScheme == .dark ? Color.black : Color.white]), startPoint: start, endPoint: end)
            .onReceive(timer, perform: { _ in
                withAnimation(.easeInOut(duration: 10).repeatForever()) {
                    self.start = .bottom
                    self.end = .leading
                    self.start = .trailing
                    self.start = .bottom
                }
            })
    }
}

struct InvoiceView_Previews: PreviewProvider {
    static var previews: some View {
        InvoiceView()
            .environmentObject(InvoiceViewModel())
    }
}
