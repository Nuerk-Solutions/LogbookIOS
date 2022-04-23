//
//  InvoiceView.swift
//  Logbook
//
//  Created by Thomas on 22.04.22.
//

import SwiftUI

struct InvoiceView: View {
    
    @StateObject private var invoiceViewModel: InvoiceViewModel = InvoiceViewModel()
    @State private var selectedDate: Date? = Date()
    @State private var dateRange: Date = Date()
    @State private var showSheet: Bool = false
    
    var body: some View {
        NavigationView {
            
            ScrollView {
                
                
                
                if showSheet {
                }
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 200))], spacing: 15) {
                    ForEach(DriverEnum.allCases, id: \.self) {item in
                        NavigationLink {
                            if !invoiceViewModel.isLoading {
                                InvoiceDetailView(invoiceModel: invoiceViewModel.invoiceList.first(where: {$0.driver == item}) ?? InvoiceModel.single)
                            }
                        } label: {
                            VStack {
                                Text(item.rawValue)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 50)
                                    .background(.thinMaterial)
                                    .foregroundColor(.primary)
                                    .shadow(radius: 0)
                            }
                        }.shadow(radius: 5)
                    }
                }
                .padding()
            }
            .background {
                AnimatedBackground()
                    .edgesIgnoringSafeArea(.all)
                    .blur(radius: 50)
                    .opacity(0.5)
            }
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    //                    Button {
                    //                        showSheet.toggle()
                    //                    } label: {
                    //                    ZStack {
                    Button(action: {
                        withAnimation {
                            showSheet.toggle()
                        }
                    }, label: {
                        Image(systemName: "calendar")
                    })
                    
                    //                    }
                    //                            .overlay {
                    //
                    //                                if showSheet {
                    //                                    DatePicker("Datumsauswahl", selection: $selectedDate, in: $dateRange, displayedComponents: [.date])
                    //                                }
                    //                            }
                    //                    }
                }
            })
            .sheet(isPresented: $showSheet, content: {
                
                    DatePickerWithButtons(showDatePicker: $showSheet, savedDate: $selectedDate, selectedDate: selectedDate ?? Date())
                        .animation(.linear)
                        .transition(.opacity)
                        .padding()
            })
            .navigationTitle("Statistik")
        }
        .task {
            await invoiceViewModel.fetchInvoice(drivers: DriverEnum.allCases, vehicles: VehicleEnum.allCases, startDate: DateFormatter.yearMonthDay.date(from: "2021-01-01")!, detailed: true)
        }
    }
}

struct AnimatedBackground: View {
    @State var start: UnitPoint = .top
    @State var end: UnitPoint = .bottom
    
    let timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    let colors = [Color.white, Color.red, Color.purple, Color.blue, Color.indigo, Color.orange, Color.white]
    
    var body: some View {
        
        LinearGradient(gradient: Gradient(colors: colors), startPoint: start, endPoint: end)
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

struct DatePickerWithButtons: View {
    
    @Binding var showDatePicker: Bool
    @Binding var savedDate: Date?
    @State var selectedDate: Date = Date()
    
    var body: some View {
        ZStack {
            
//            Color.black.opacity(0.3)
//                .edgesIgnoringSafeArea(.all)
//
            
            VStack {
                DatePicker("Test", selection: $selectedDate, displayedComponents: [.date])
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .labelsHidden()
                
                Divider()
                HStack {
                    
                    Button(action: {
                        showDatePicker = false
                    }, label: {
                        Text("Abbrechen")
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        savedDate = selectedDate
                        showDatePicker = false
                    }, label: {
                        Text("Speichern".uppercased())
                            .bold()
                    })
                    
                }
                .padding(.horizontal)
                
            }
            .padding()
            .background(
                Color.white
                    .cornerRadius(30)
            )
            
            
        }
        
    }
}

struct InvoiceView_Previews: PreviewProvider {
    static var previews: some View {
        InvoiceView()
            .environmentObject(InvoiceViewModel())
    }
}
