//
//  ListView.swift
//  Logbook
//
//  Created by Thomas on 05.01.22.
//

import SwiftUI
import SPAlert
import AlertKit
import KeyboardAvoider
import PermissionsSwiftUINotification
import PermissionsSwiftUILocationAlways
import CoreLocation

struct ListView: View {
    @StateObject var listViewModel = ListViewModel()
    @StateObject var alertManager = AlertManager()
    
    @State private var editMode = EditMode.inactive
    @State private var searchText = ""
    @State private var shouldLoad = true
    @State var logbooks: [LogbookModel] = []
    
    @State private var showAddSheet: Bool = false
    @State private var showRefuelSheet: Bool = false
    @State private var showSettingsSheet: Bool = false
    @State private var showActivitySheet: Bool = false
    @State private var showExportSheet: Bool = false
    
    @State private var showModal: Bool = true
    
    @State private var isInvoiceLink: Bool = false
    @State private var invoiceLinkDriver: DriverEnum?
    @State private var invoiceLinkStartDate: Date?
    @State private var invoiceLinkEndDate: Date?
    
    @Preference(\.openAddViewOnStart) var openAddViewOnStart
    @Preference(\.allowLocationTracking) var allowLocationTracking
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var locationService: LocationService
    
    init() {
        UITableView.appearance().sectionFooterHeight = 0
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach($listViewModel.originalLogbooks) { $logbook in
                    ListRowView(logbook: $logbook, isFirstItem: listViewModel.originalLogbooks.firstIndex(of: logbook) == 0)
                        .environmentObject(listViewModel)
                        .onAppear {
                            listViewModel.loadMoreContentIfNeeded(currentItem: logbook)
                        }
                }
                if listViewModel.isLoadingPage {
                    ProgressView("Einträge laden (\(listViewModel.currentPage))")
                        .frame(maxWidth: .infinity)
                        .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                }
            }
            .listStyle(InsetGroupedListStyle())
            .refreshable {
                DispatchQueue.main.async {
                    listViewModel.refresh(extend: false)
                }
            }
            .navigationTitle("Fahrtenbuch")
            .toolbar(content: {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    if allowLocationTracking {
                        RefuelButton
                    }
                }
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    AddButton.disabled(listViewModel.isLoading)
                }
            })
            .overlay(
                Group {
                    if listViewModel.isLoading {
                        CustomProgressView(message: "Laden...")
                    }
                }
            )
            .alert(isPresented: $listViewModel.showAlert, content: {
                Alert(title: Text("Fehler!"), message: Text(listViewModel.errorMessage ?? ""))
            })
            //            .searchable(text: $listViewModel.searchTerm)
            //            .task {
            //                if shouldLoad && !usePagination {
            //                    await listViewModel.fetchAllLogbooks()
            //                    shouldLoad = false
            //                }
            //            }
            
            .onReceive(listViewModel.$originalLogbooks) { newValue in
                if openAddViewOnStart {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.35) {
                        if listViewModel.isLoading {
                            return
                        }
                        showAddSheet = true
                    }
                }
            }
            .uses(alertManager)
                        .JMModal(showModal: $showModal, for: [.locationAlways, .notification], autoDismiss: true, autoCheckAuthorization: true, restrictDismissal: false, onAppear: {}, onDisappear: {
                            if CLLocationManager.locationServicesEnabled() {
                                switch CLLocationManager().authorizationStatus {
                                    case .notDetermined, .restricted, .denied:
                                        allowLocationTracking = false
                                        print("No access")
                                    case .authorizedAlways, .authorizedWhenInUse:
                                        print("Access")
                                    @unknown default:
                                        allowLocationTracking = false
                                        break
                                }
                            } else {
                                allowLocationTracking = false
                                print("Location services are not enabled")
                            }
                            if openAddViewOnStart {
                                if listViewModel.isLoading {
                                    return
                                }
                                showAddSheet = true
                            }
                        })
                        .changeHeaderTo("Berechtigungen")
                        .changeHeaderDescriptionTo("Damit du bestimmte Funktionen dieser App benutzen kannst, musst du entsprechende Berechtigungen freigeben.")
                        .changeBottomDescriptionTo("Diese Berechtigungen sind notwendig, damit alle Features richtig funktionieren. Ohne die Standortfreigabe ist es nicht möglich, das Tankstellen Feature zu benutzen. Ohne die Erlaubnis für Benachrichtigungen bekommst du keine Information, wenn du dich dem ARB 19 näherst.")
                        .setPermissionComponent(for: .notification, title: "Benachrichtigungen")
                        .setPermissionComponent(for: .notification, description: "Erlaube Benachrichtigungen")
                        .setPermissionComponent(for: .locationAlways, title: "Standort immer")
                        .setPermissionComponent(for: .locationAlways, description: "Dauerhafte Standortfreigabe erlauben")
        }
        .sheet(isPresented: $isInvoiceLink, content: {
            InvoiceLinkOverview(driver: $invoiceLinkDriver, startDate: $invoiceLinkStartDate, endDate: $invoiceLinkEndDate)
                .onAppear {
                    print("******")
                    print(invoiceLinkStartDate!)
                }
        })
        .onOpenURL { url in
            guard let driverIdentifier = url.driverIdentifier else {
                return
            }
            guard let startDate = url.startDateIdentifier else {
                return
            }
            guard let endDate = url.endDateIdentifier else {
                return
            }
            invoiceLinkDriver = driverIdentifier
            invoiceLinkStartDate = startDate
            invoiceLinkEndDate = endDate
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                isInvoiceLink = true
            }
        }
    }
    
    
    private var SettingsButton: some View {
        return AnyView(
            Button(action: {
                showSettingsSheet.toggle()
            }, label: {
                Image(systemName: "gearshape")
                    .resizable()
                    .frame(width: 35, height: 35)
            })
            .sheet(isPresented: $showSettingsSheet, content: {
                SettingsView()
            })
        )
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
                RefuelView()
                    .ignoresSafeArea(.all, edges: .all)
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
                    NavigationView {
                        AddLogbookView(showSheet: $showAddSheet)
                            .environmentObject(listViewModel)
                            .navigationTitle("Neuer Eintrag")
                    }
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                }
            })
        )
    }
    
    var searchResults: [LogbookModel] {
        withAnimation {
            if searchText.isEmpty {
                return listViewModel.logbooks
            } else {
                return listViewModel.logbooks.filter{$0.driveReason.contains(searchText) || $0.driver.id.contains(searchText)}
            }
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

