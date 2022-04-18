//
//  SettingsView.swift
//  Logbook
//
//  Created by Thomas on 15.03.22.
//

import SwiftUI
import CorePermissionsSwiftUI
import PermissionsSwiftUINotification
import PermissionsSwiftUILocationAlways

struct SettingsView: View {
    
    @Preference(\.allowLocationTracking) var allowLocationTracking
    @Preference(\.notifications) var notifications
    @Preference(\.notificationsIconBadge) var notificationsIconBadge
    @Preference(\.openAddViewOnStart) var openAddViewOnStart
    @Preference(\.openActivityViewAfterExport) var openActivityViewAfterExport
    @Preference(\.developerconsole) var developerconsole
    @Preference(\.measureSpeed) var measureSpeed
    @Preference(\.hideKeyboardOnDrag) var hideKeyboardOnDrag
    @Preference(\.usePagination) var usePagination
    @EnvironmentObject private var locationService: LocationService
    
    @State private var showExportSheet: Bool = false
    @State private var showLocationPermissionSheet: Bool = false
    @State private var showNotificationPermissionSheet: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Toggle(isOn: $allowLocationTracking.animation()) {
                        Text("Tracking erlauben")
                    }
                    .onChange(of: allowLocationTracking) { newValue in
                        if !newValue {
                            locationService.locationManager.stopUpdatingLocation()
                        } else {
                            showLocationPermissionSheet = true
                        }
                    }
                } header: {
                    Text("Standort")
                } footer: {
                    Text("Durch das Deaktivieren dieser Option ist es nicht möglich, die Funktion Tankstellensuche und Benachrichtigungen zu benutzen.")
                }
                if allowLocationTracking {
                    Section {
                        Toggle(isOn: $notifications.animation()) {
                            Text("Benachrichtigungen")
                        }
                        .onChange(of: notifications) { newValue in
                            if newValue {
                                showNotificationPermissionSheet = true
                            }
                        }
                        if notifications {
                            Toggle(isOn: $notificationsIconBadge) {
                                Text("Icon Badge")
                            }
                        }
                    } header: {
                        Text("Benachrichtigung")
                    } footer: {
                        Text("Du bekommst eine Benachrichtigung, wenn du außerhalb eines Umkreises von 550m dem ARB 19 wieder näher kommst.")
                    }
                }
                
                Section {
                    Toggle(isOn: $openAddViewOnStart) {
                        Text("Neuer Eintrag beim Starten anzeigen")
                    }
                    Toggle(isOn: $openActivityViewAfterExport) {
                        Text("Aktivitätsansicht nach dem Export öffnen")
                    }
                    Toggle(isOn: $hideKeyboardOnDrag) {
                        Text("Verstecke Tastatur bei berühren")
                    }
                    Toggle(isOn: $usePagination) {
                        Text("Seitenweises laden der Einträge")
                    }
                } header: {
                    Text("Funktionen")
                }
                
                Section {
                    Toggle(isOn: $developerconsole.animation()) {
                        Text("Console")
                    }
                    .onChange(of: developerconsole) { newValue in
                            consoleManager.isVisible = newValue
                        if !newValue {
                            locationService.locationManager.stopUpdatingLocation()
                        } else {
                            if measureSpeed {
                                locationService.locationManager.startUpdatingLocation()
                            }
                        }
                    }
                    if allowLocationTracking {
                        Toggle(isOn: $measureSpeed.animation()) {
                            Text("Measure Speed")
                        }
                        if measureSpeed {
                            NavigationLink("Tracking", destination: TrackingView())
                        }
                    }
                } header: {
                    Text("Dev")
                }
                
                Section {
                    SettingsRowView(name: "Version", content: "1.0")
                    SettingsRowView(name: "Build", content: "23")
                } header: {
                    Text("App")
                }
            }
            .navigationTitle("Einstellungen")
            
            .toolbar(content: {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    ExportButton
                }
            })
            
            .JMModal(showModal: $showNotificationPermissionSheet, for: [.locationAlways, .notification], autoDismiss: true, autoCheckAuthorization: true, restrictDismissal: false)
            .changeHeaderTo("Berechtigung")
            .changeHeaderDescriptionTo("Damit du bestimmte Funktionen dieser App benutzen kannst, musst du entsprechende Berechtigungen freigeben.")
            .changeBottomDescriptionTo("Diese Berechtigungen sind notwendig, damit alle Features richtig funktionieren. Ohne die Erlaubnis für Berichtigungen bekommst du keine Information wenn du dich dem ARB 19 näherst.")
            .setPermissionComponent(for: .notification, title: "Benachrichtigungen")
            .setPermissionComponent(for: .notification, description: "Erlaube Benachrichtigungen")
            
            .JMModal(showModal: $showLocationPermissionSheet, for: [.locationAlways,], autoDismiss: true, autoCheckAuthorization: true, restrictDismissal: false, onAppear: {}, onDisappear: {
                if !locationService.hasPermission() {
                    allowLocationTracking = false
                }
            })
            .changeHeaderTo("Berechtigung")
            .changeHeaderDescriptionTo("Damit du bestimmte Funktionen dieser App benutzen kannst, musst du entsprechende Berechtigungen freigeben.")
            .changeBottomDescriptionTo("Diese Berechtigungen sind notwendig, damit alle Features richtig funktionieren. Ohne die Standortfreigabe ist es nicht möglich, das Tankstellen Feature zu benutzen.")
            .setPermissionComponent(for: .locationAlways, title: "Standort immer")
            .setPermissionComponent(for: .locationAlways, description: "Dauerhafte Standortfreigabe erlauben")
        }
    }
    
    
    
    private var ExportButton: some View {
        
        return AnyView(
            Button(action: {
                showExportSheet.toggle()
            }, label: {
                Image(systemName: "square.and.arrow.up")
                    .resizable()
                    .frame(width: 24, height: 30)
                    .padding()
                    .font(Font.title.weight(.semibold))
            })
            .sheet(isPresented: $showExportSheet, content: {
                ExportView(driver: DriverEnum.allCases, selectedDrivers: DriverEnum.allCases, vehicle: VehicleEnum.allCases, selectedVehicles: VehicleEnum.allCases, showActivitySheet: $showExportSheet)
            })
        )
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
