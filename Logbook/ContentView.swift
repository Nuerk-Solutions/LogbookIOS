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
    
    var body: some View {
        ZStack {
//            Color(hex: "17203A").ignoresSafeArea()
            
            Group {
            switch selectedTab {
            case .home:
                ListView(lastRefreshDate: $lastRefreshDate)
                    .environmentObject(model)
                    .environmentObject(networkReachablility)
                    .environmentObject(logbooksVM)
            case .gasStations:
                if ContentView.isPreview {
                    GasStationsView(gasStations: GasStationWelcome.previewData.data.tankstellen)
                } else {
                    GasStationsView()
                }
            case .stats:
                BarChart()
            case .settings:
                SettingsView()
            }
                        }
                        .safeAreaInset(edge: .bottom) {
//                            VStack {}.frame(height: model.showTab ? 44 : 0)
                            VStack {}.frame(height: 44)
                        }
            
            
            TabBar()
//                            .offset(y: -24)
//                .background(
//                    LinearGradient(colors: [Color("Background").opacity(0), Color("Background")], startPoint: .top, endPoint: .bottom)
//                        .frame(height: 100)
//                        .frame(maxHeight: .infinity, alignment: .bottom)
//                        .allowsHitTesting(false)
//                        .blur(radius: 15)
//                )
//                            .ignoresSafeArea()
//                .offset(y: isOpen ? 300 : 0)
                .offset(y: !model.showTab ? 200 : 0)
            
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
                .presentationBackground(.ultraThinMaterial)
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
            .preferredColorScheme(.dark)
        //            .previewInterfaceOrientation(.landscapeRight)
    }
}
