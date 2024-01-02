//
//  SettingsView.swift
//  Logbook
//
//  Created by Thomas on 12.06.22.
//

import SwiftUI

struct SettingsView: View {
    @State var isPinned = false
    @State var isDeleted = false
    @State var isLogged = true
    
    @AppStorage("gasStationRadius") var gasStationRadius: Int = 5
    var intProxy: Binding<Double>{
        Binding<Double>(get: {
            //returns the score as a Double
            return Double(gasStationRadius)
        }, set: {
            //rounds the double to an Int
            gasStationRadius = Int($0)
        })
    }
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var iconSettings: IconNames = IconNames()
    
    @AppStorage("currentDriver") var currentDriver: DriverEnum = .Andrea
    @AppStorage("gasStationSort") var gasStationSort: SortTyp = .Preis
    @AppStorage("isGasStationSortDirectionAsc") var isGasStationSortDirectionAsc: Bool = true
    @AppStorage("isAllowLocationTracking") var isAllowLocationTracking = false
    @AppStorage("isShowNotifications") var isShowNotifications = false
    @AppStorage("isShowNotificationsIconBadge") var isShowNotificationsIconBadge = false
    @AppStorage("isOpenAddViewOnStart") var isOpenAddViewOnStart = false
    @AppStorage("isRememberLastDriver") var isRememberLastDriver = false
    @AppStorage("isIntelligentGasStationRadius") var isIntelligentGasStationRadius = false
    @AppStorage("isIntelligentGasStationSelection") var isIntelligentGasStationSelection = false
    @AppStorage("isUseNotSuperScript") var isUseNotSuperScript = false
    
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    profile
                }
                
                Section {
                    Toggle(isOn: $isAllowLocationTracking.animation()) {
                        Text("Tracking erlauben")
                    }
                } header: {
                    Text("Standort")
                } footer: {
                    Text("Durch das Deaktivieren dieser Option ist es nicht möglich, die Funktion Tankstellensuche und Benachrichtigungen zu benutzen.")
                }
                
                if isAllowLocationTracking {
                    Section {
                        Toggle(isOn: $isShowNotifications.animation()) {
                            Label("Benachrichtigungen", systemImage: isShowNotifications ? "bell" : "bell.slash")
                        }
                        if isShowNotifications {
                            Toggle(isOn: $isShowNotificationsIconBadge) {
                                Label("Icon Badge", systemImage: "bell.badge")
                            }
                        }
                    } header: {
                        Text("Benachrichtigung")
                    } footer: {
                        Text("Du bekommst eine Benachrichtigung, wenn du außerhalb eines Umkreises von 600m dem ARB 19 wieder näher kommst.")
                    }
                    .disabled(true)
                    
                    Section {
                        Toggle(isOn: $isIntelligentGasStationRadius.animation()) {
                            Label("Intelligenter Suchradius", systemImage: "smallcircle.filled.circle")
                        }
                        
                        if !isIntelligentGasStationRadius {
                            Slider(value: intProxy, in: 1...50) {
                                Text("Suchradius")
                            } minimumValueLabel: {
                                Text("\(gasStationRadius)km")
                            } maximumValueLabel: {
                                Text("50km")
                            }
                        }
                        
                        Picker(selection: $gasStationSort, content: {
                            
                            ForEach(SortTyp.allCases, id: \.self) {
                                Text($0.description)
                            }
                        }, label: {
                            Label("Sortieren nach", systemImage: "list.number")
                        })
                        
                        Toggle(isOn: $isGasStationSortDirectionAsc.animation()) {
                            Label("Aufsteigend Sortieren", systemImage: isGasStationSortDirectionAsc ? "arrow.up.arrow.down.square.fill" : "arrow.up.arrow.down.square")
                        }
                        //                        Toggle(isOn: $isIntelligentGasStationSelection) {
                        //                            Label("Intelligente Auswahl", systemImage: "filemenu.and.selection")
                        //                        }
                        Toggle(isOn: $isUseNotSuperScript) {
                            Label("Vereinfachter Preis", systemImage: "textformat.superscript")
                        }
                    } header: {
                        Text("Tanken")
                    } footer: {
                        Text("Der Tankstellenradius wird mit zunehmender Geschwindigkeit automatisch auf bis zu 50 km vergrößert.")
//                        \n\nMit der intelligenten Auswahl werden nur Tankstellen in Fahrtrichtung bis zu einem Winkel von 65° angezeigt.
                    }
                }
                
                Section {
                    Toggle(isOn: $isOpenAddViewOnStart) {
                        Label("Neuer Eintrag anzeigen", systemImage: "doc.badge.plus")
                        
                    }
                }
                    
//                    Toggle(isOn: $isRememberLastDriver) {
//                        Label("Letztes Fahrzeug merken", systemImage: isRememberLastDriver ? "person.fill.checkmark" : "person.fill.xmark")
//                    }
                
                Section {
                    
                    Picker(selection: $iconSettings.currentIndex) {
                        ForEach(0 ..< iconSettings.iconNames.count, id: \.self) { icon in
                            HStack(spacing: 20) {
                                Image(uiImage: UIImage(named: self.iconSettings.iconNames[icon] ?? "AppIcon") ?? UIImage())
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40, alignment: .leading)
                                Text(self.iconSettings.iconNames[icon] ?? "Standard")
                            }
                        }
                    } label: {
                        Text("App Icon")
                    }
                    .onReceive([self.iconSettings.currentIndex].publisher.first()) { value in
                        
                        let index = self.iconSettings.iconNames.firstIndex(of: UIApplication.shared.alternateIconName) ?? 0
                        if value != index {
                            UIApplication.shared.setAlternateIconName(self.iconSettings.iconNames[value], completionHandler: {
                                error in
                                if let error = error {
                                    print(error.localizedDescription)
                                } else {
                                    print("Success!")
                                }
                            })
                        }
                    }
                }
                
                //                Button {} label: {
                //                    Text("Sign out")
                //                        .frame(maxWidth: .infinity)
                //                }
                //                .tint(.red)
                //                .onTapGesture {
                //                    isLogged = false
                //                    presentationMode.wrappedValue.dismiss()
                //                }
                Section {
                    VStack {
                        Text("Made with ❤️")
                        Text("v\(Bundle.main.appVersionLong) (\(Bundle.main.appBuild))")
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .listRowInsets(EdgeInsets())
                    .background(Color(UIColor.systemGroupedBackground))
                    .foregroundColor(.gray)
                    .font(.caption)
                }
                .frame(minHeight: 100)
            }
            .navigationTitle("Account")
            .listStyle(.insetGrouped)
            .refreshable {
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        Form {
                            ForEach(VehicleEnum.allCases) { vehicle in
                                Section {
                                    Text(vehicle.fuelDescription)
//                                    .padding()
                                } header: {
                                    HStack {
                                        Image(vehicle.rawValue)
                                                .resizable()
                                                .frame(width: 60, height: 60, alignment: .center)
                                        Text(vehicle.rawValue)
                                    }
                                }
                                .headerProminence(.increased)
                            }
                        }
                        .navigationBarTitleDisplayMode(.inline)
                    } label: {
                        Image(systemName: "info.circle")
                            .padding()
                    }

                }
            }
        }
        .navigationViewStyle(.stack)
    }
    
    var profile: some View {
        VStack {
            ZStack {
                Picker("", selection: $currentDriver.animation()) {
                    ForEach(DriverEnum.allCases) { driver in
                        Text(driver.rawValue)
                            .tag(driver)
                    }
                }
                .frame(width: 75, height: 75)
                .labelsHidden()
                //                .pickerStyle(.menu)
                .customPickerStyle(heigth: 50, width: 50)
                //            .customFont(.body)
                SwiftUIWrapper {
                    Image(systemName: "person.crop.circle.fill.badge.checkmark")
                        .symbolVariant(.circle.fill)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.blue, .blue.opacity(0.3), .red)
                        .font(.system(size: 32))
                        .padding()
                        .background(Circle().fill(.ultraThinMaterial))
                        .background(AnimatedBlobView().frame(width: 400, height: 414).offset(x: 200, y: 0).scaleEffect(0.5))
                        .background(HexagonView().offset(x: -50, y: -100))
                }
                .allowsHitTesting(false)
                .frame(width: 50, height: 50, alignment: .center)
                
                
            }
            Text(currentDriver.rawValue)
                .font(.title.weight(.semibold))
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}


struct SwiftUIWrapper<T: View>: UIViewControllerRepresentable {
    let content: () -> T
    func makeUIViewController(context: Context) -> UIHostingController<T> {
        UIHostingController(rootView: content())
    }
    func updateUIViewController(_ uiViewController: UIHostingController<T>, context: Context) {}
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .preferredColorScheme(.dark)
    }
}
struct CustomPickerStyle: ViewModifier {
    var width: CGFloat
    var heigth: CGFloat
    
    func body(content: Content) -> some View {
        Menu {
            content
        } label: {
            HStack {
            }
            .frame(maxWidth: width, maxHeight: heigth, alignment: .leading)
            .padding()
        }
    }
}
extension View {
    func customPickerStyle(heigth: CGFloat, width: CGFloat) -> some View {
        self.modifier(CustomPickerStyle(width: width, heigth: heigth))
    }
}
