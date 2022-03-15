//
//  ListView.swift
//  Logbook
//
//  Created by Thomas on 05.01.22.
//

import SwiftUI
import PopupView
import SPAlert
import AlertKit
import KeyboardAvoider

struct ListView: View {
    @StateObject var listViewModel = ListViewModel()
    @StateObject var alertManager = AlertManager()
    @StateObject private var locationService: LocationService
    
    @State private var editMode = EditMode.inactive
    @State private var searchText = ""
    @State private var shouldLoad = true
    
    @State private var showAddSheet: Bool = false
    @State private var showRefuelSheet: Bool = false
    @State private var showActivitySheet: Bool = false
    @State private var showExportSheet: Bool = false
    @State private var loadedAmount = 0.0
    let timer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()
    
    let readableDateFormat: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.locale = Locale(identifier: "de")
        return dateFormatter
    }()
    
    
    @Environment(\.presentationMode) var presentationMode
    
    init() {
        UITableView.appearance().sectionFooterHeight = 0
        _locationService = StateObject(wrappedValue: LocationService())
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(searchResults) { logbook in
                    Section {
                        NavigationLink {
                            DetailView(logbookId: logbook._id)
                        } label: {
                            HStack {
                                Image(logbook.vehicleTyp == .VW ? "car_vw" : logbook.vehicleTyp == .Ferrari ? "logo_small" : "porsche")
                                    .resizable()
                                    .scaledToFit()
                                    .scaleEffect(logbook.vehicleTyp == .Porsche ? 2.2 : 1)
                                    .frame(width: 80, height: 75)
                                    .offset(x: logbook.vehicleTyp == .Porsche ? 15 : 0)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(logbook.vehicleTyp == .VW ? Color.blue : logbook.vehicleTyp == .Ferrari ? Color.black : Color.gray, lineWidth: 1).opacity(0.5))
                                VStack(alignment: .leading) {
                                    Text(logbook.driveReason)
                                        .font(.headline)
                                    Text(self.readableDateFormat.string(from: logbook.date))
                                    Text(logbook.driver.id)
                                        .font(.subheadline)
                                }.padding(.leading, 8)
                            }.padding(.init(top: 6, leading: 0, bottom: 6, trailing: 0))
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .refreshable {
                Task {
                    await listViewModel.fetchLogbooks()
                }
            }
            .navigationTitle("Fahrtenbuch")
            .toolbar(content: {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    AddButton
                }
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    RefuelButton
                    ExportButton
                }
            })
            .overlay(
                Group {
                    if listViewModel.isLoading {
                        if loadedAmount != 100 {
                            VStack {
                            ProgressView(loadingText, value: loadedAmount, total: 100)
                                .onReceive(timer) { _ in
                                    if loadedAmount < 100 {
                                        loadedAmount += 1
                                    }
                                }
                            }
                        } else {
                            CustomProgressView(message: "Laden")
                        }
                    }
                    
                    if(listViewModel.errorMessage != nil) {
                        VStack {
                            Text("Bitte verbinde dich mit dem Internet um einen neuen Eintrag hinzuzufügen!").foregroundColor(.red)
                                .fontWeight(.bold)
                                .font(.title)
                        }.onAppear {
                            withAnimation {
                                listViewModel.logbooks.removeAll()
                            }
                        }
                    }
                }
            )
            
            .alert(isPresented: $listViewModel.showAlert, content: {
                Alert(title: Text("Fehler!"), message: Text(listViewModel.errorMessage ?? ""))
            })
            .searchable(text: $searchText)
            .onAppear {
                if shouldLoad {
                    locationService.requestLocationPermission(always: true)
                    Task {
                        await listViewModel.fetchLogbooks()
                    }
                    shouldLoad = false
                    //                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.35) {
                    //                        showAddSheet = true
                    //                    }
                }
            }
        }
        .onTapGesture(count: 4) {
            consoleManager.isVisible.toggle()
        }
        .uses(alertManager)
    }
    
    private var RefuelButton: some View {
        return AnyView(
            Button(action: {
                showRefuelSheet.toggle()
            }, label: {
                Image(systemName: "fuelpump.circle")
                    .resizable()
                    .frame(width: 35, height: 35)
            })
            .sheet(isPresented: $showRefuelSheet, content: {
                RefuelView(locationService: locationService)
                    .ignoresSafeArea(.all, edges: .all)
            })
        )
    }
    
    private var ExportButton: some View {
        
        return AnyView(
            Button(action: {
                showExportSheet.toggle()
            }, label: {
                Image(systemName: "square.and.arrow.up")
                    .resizable()
                    .frame(width: 24, height: 30)
                    .padding(.bottom, 3)
                    .font(Font.title.weight(.semibold))
            })
            .sheet(isPresented: $showExportSheet, content: {
                ExportView(driver: DriverEnum.allCases, selectedDrivers: DriverEnum.allCases, vehicle: VehicleEnum.allCases, selectedVehicles: VehicleEnum.allCases, showActivitySheet: $showExportSheet)
                    .overlay(
                        Group (content: {
                            if listViewModel.isLoading {
                                CustomProgressView(message: "Laden...")
                            }
                        })
                    )
            })
        )
    }
    
    private var AddButton: some View {
        return AnyView(
            Button( action: {
                showAddSheet.toggle()
            }, label: {
                Image(systemName: "plus.circle")
                    .resizable()
                    .frame(width: 35, height: 35)
            })
            .disabled((listViewModel.errorMessage) != nil)
            .sheet(isPresented: $showAddSheet, content: {
                if(listViewModel.isLoading) {
                    CustomProgressView(message: "Laden...")
                } else {
                    AddLogbookView(showSheet: $showAddSheet)
                        .avoidKeyboard()
                        .environmentObject(listViewModel)
                        .ignoresSafeArea(.all, edges: .all)
                }
            })
        )
    }
    
    var searchResults: [LogbookModel] {
        if searchText.isEmpty {
            return listViewModel.logbooks
        } else {
            return listViewModel.logbooks.filter{$0.driveReason.contains(searchText) || readableDateFormat.string(from: $0.date).contains(searchText) || $0.driver.id.contains(searchText)}
        }
    }
    
    var loadingText: String {
        switch loadedAmount {
        case 0...10:
            return "Server anfragen..."
        case 20...30:
            return "Starte..."
        case 30...40:
            return "Datenbank initialisieren..."
        case 40...50:
            return "Starte..."
        case 50...60:
            return "Anfrage überprüfen..."
        case 60...70:
            return "Authentifizierung..."
        case 70...80:
            return "Warten..."
        case 80...90:
            return "Verbindung aufbauen..."
        case 90...100:
            return "Daten abrufen..."
        default:
            return "Laden..."
        }
    }
}


struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ListView()
        }
    }
}

