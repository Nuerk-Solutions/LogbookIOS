//
//  ContentView.swift
//  Logbook
//
//  Created by Thomas on 26.05.22.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var logbooksVM: LogbooksViewModel = LogbooksViewModel()
    
    @EnvironmentObject var model: Model
    @EnvironmentObject var networkReachablility: NetworkReachability
    @AppStorage("selectedTab") var selectedTab: Tab = .home
    
    @State private var scrollPositionInList = 0.0
    
    @State var isOpen = false
    @State var lastRefreshDate: Date? = nil
    
    private static let isPreview = false
    
    @AppStorage("isOpenAddViewOnStart") var isOpenAddViewOnStart = false
    @Namespace var dummyNameSpace
    
    var body: some View {
        ZStack {
            Color(hex: "17203A").ignoresSafeArea()
            TabView(selection: $selectedTab) {
                NewListView()
                    .tag(Tab.home)
                    .environmentObject(logbooksVM)
                    .toolbar {
                        ToolbarItem(placement: .keyboard) {
                            HStack {
                                Spacer()
                                Button("Fertig", role: .cancel) {
                                    hideKeyboard()
                                }
                                .foregroundStyle(.accent)
                            }
                        }
                    }
                if ContentView.isPreview {
                    GasStationsView(gasStations: GasStationWelcome.previewData.data.tankstellen)
                        .tag(Tab.gasStations)
                } else {
                    GasStationsView()
                        .tag(Tab.gasStations)
                }
                
                BarChart()
                    .tag(Tab.stats)
                
                SettingsView()
                    .tag(Tab.settings)
            }
            
            TabBar()
            
        }
        .dynamicTypeSize(.large ... .xxLarge)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.spring()) {
                    model.showAdd = isOpenAddViewOnStart
//                    model.showTab = !isOpenAddViewOnStart
                }
            }
            //            isInitalLoad.toggle()
        }
        .sheet(isPresented: $model.showAdd) {
            AddEntryView(show: $model.showAdd)
                .presentationBackground(.thinMaterial)
                .presentationCornerRadius(30)
                .presentationDetents([.large])
                .environmentObject(logbooksVM)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Model())
            .environmentObject(NetworkReachability())
    }
}
