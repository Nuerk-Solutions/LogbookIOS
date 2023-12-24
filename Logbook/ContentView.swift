//
//  ContentView.swift
//  Logbook
//
//  Created by Thomas on 26.05.22.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var model: Model
    @EnvironmentObject var networkReachablility: NetworkReachability
    @AppStorage("selectedTab") var selectedTab: Tab = .stats
    @AppStorage("showAccount") var showAccount = false
    
    @State private var scrollPositionInList = 0.0
    
    @State var isOpen = false
    @State var lastRefreshDate: Date? = nil
    
    private static let isPreview = false
    
    @Preference(\.isOpenAddViewOnStart) var isOpenAddViewOnStart
    
    init() {
        showAccount = false
    }
    
    var body: some View {
        ZStack {
            //Color(hex: "17203A").ignoresSafeArea()
            
            //            SideMenu()
            
                        Group {
            switch selectedTab {
            case .home:
                ListView(showAdd: $model.showTab, lastRefreshDate: $lastRefreshDate)
                    .environmentObject(model)
                    .environmentObject(networkReachablility)
            case .gasStations:
                if ContentView.isPreview {
                    GasStationsView(gasStations: GasStationWelcome.previewData.data.tankstellen)
                } else {
                    GasStationsView()
                }
            case .stats:
                StatsView()
            case .settings:
                SettingsView()
            }
                        }
                        .safeAreaInset(edge: .bottom) {
                            VStack {}.frame(height: model.showTab ? 44 : 0)
                        }
            
            
            TabBar()
//                            .offset(y: -24)
                .background(
                    LinearGradient(colors: [Color("Background").opacity(0), Color("Background")], startPoint: .top, endPoint: .bottom)
                        .frame(height: 100)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .allowsHitTesting(false)
                        .blur(radius: 15)
                )
//                            .ignoresSafeArea()
                .offset(y: isOpen ? 300 : 0)
                .offset(y: !model.showTab ? 200 : 0)
            
            
            
            //            Image(systemName: "person")
            //                .frame(width: 36, height: 36)
            //                .background(.background)
            //                .mask(Circle())
            //                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            //                .shadow(color: Color("Shadow").opacity(0.2), radius: 5, x: 0, y: 5)
            //                .padding()
            //                .offset(y: 4)
            //                .offset(x: isOpen ? 100 : 0)
            //                .onTapGesture {
            //                    withAnimation(.spring()) {
            //                        model.showAdd.toggle()
            //                    }
            //                }
            
            if model.showAdd {
                AddEntryView(show: $model.showAdd, showTab: $model.showTab, lastAddedEntry: $model.lastAddedEntry)
                    .background(.regularMaterial)
                    .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .shadow(color: .black.opacity(0.5), radius: 40, x: 0, y: 40)
                    .ignoresSafeArea(.all, edges: .top)
                    .offset(y: model.showAdd ? -10 : 0)
                    .zIndex(1)
                    .transition(.opacity.combined(with: .move(edge: .top)))
                    .frame(maxWidth: .infinity, minHeight: 600, maxHeight: .infinity)
                //                Spacer()
            }
        }
        //        .clipped()
        .dynamicTypeSize(.large ... .xxLarge)
        .sheet(isPresented: $showAccount) {
            EmptyView()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.spring()) {
                    model.showAdd = isOpenAddViewOnStart
                    model.showTab = !isOpenAddViewOnStart
                }
            }
            //            isInitalLoad.toggle()
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
