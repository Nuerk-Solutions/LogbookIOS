//
//  SettingsView.swift
//  Logbook
//
//  Created by Thomas on 15.03.22.
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage("allowLocationTracking") private var allowLocationTracking = false
    @AppStorage("notifications") private var showNotifications = true
    @AppStorage("notificationsIconBadge") private var notificationsIconBadge = true
    @AppStorage("openAddViewOnStart") private var openAddViewOnStart = true
    @AppStorage("openActivityViewAfterExport") private var openActivityViewAfterExport = false
    @EnvironmentObject private var locationService: LocationService
    
    @State private var developerconsole = false
    @State private var measureSpeed = false
    @State private var showExportSheet: Bool = false
    
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
                        }
                    }
                } header: {
                    Text("Standort")
                } footer: {
                    Text("Durch das deaktivieren dieser Option, ist es nicht möglich die Funktion Tankstellensuche und Benarichtigung zu benutzen.")
                }
                if allowLocationTracking {
                    Section {
                        Toggle(isOn: $showNotifications) {
                            Text("Benarichtigungen")
                        }
                        Toggle(isOn: $notificationsIconBadge) {
                            Text("Icon Badge")
                        }.disabled(!showNotifications)
                    } header: {
                        Text("Benarichtigung")
                    } footer: {
                        Text("Du erhälst eine Benarichtigung, wenn du außerhalb eines Umkreis von 550m dem ARB 19 wieder näher kommst.")
                    }
                }
                
                Section {
                    Toggle(isOn: $openAddViewOnStart) {
                        Text("Neuer Eintrag beim starten anzeigen")
                    }
                    Toggle(isOn: $openActivityViewAfterExport) {
                        Text("Aktivitätsansicht nach dem Export öffnen")
                    }
                } header: {
                    Text("Funktionen")
                }
                
                Section {
                    Toggle(isOn: $developerconsole.animation()) {
                        Text("Developer Console")
                    }
                    .onChange(of: developerconsole) { newValue in
                            consoleManager.isVisible.toggle()
                    }
                    if developerconsole {
                        Toggle(isOn: $measureSpeed) {
                            Text("Measure Speed")
                        }
                    }
                } header: {
                    Text("Sitzungseinstellungen")
                }
                
                Section {
                    SettingsRowView(name: "Version", content: "1.0")
                    SettingsRowView(name: "Build", content: "13")
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
