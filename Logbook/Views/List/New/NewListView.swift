//
//  NewListView.swift
//  Logbook
//
//  Created by Thomas Nürk on 11.02.24.
//

import SwiftUI
import AlertKit

struct NewListView: View {
    
    @State private var searchString: String = ""
    @State private var showStatusBar = true
    @Namespace var namespace
    
    @EnvironmentObject var model: Model
    @EnvironmentObject var networkReachablility: NetworkReachability
    @EnvironmentObject var logbooksVM: LogbooksViewModel
    @StateObject private var nAIM = NetworkActivityIndicatorManager()
    
    @AppStorage("isLiteMode") private var isLiteMode: Bool = false
    
    
    var body: some View {
        NavigationStack {
            ListContent(logbooks: filteredLogbooks)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        AddLogbookButton()
                            .padding(.bottom, 10)
                    }
                }
                .overlay {
                    if  logbooksVM.isFetchingNextPage || nAIM.isVisible {
                        ZStack{}
                            .onAppear {
                                AlertKitAPI.present(
                                    title: "Laden...",
                                    icon: .spinnerSmall,
                                    style: .iOS17AppleMusic,
                                    haptic: AlertHaptic.none
                                )
                            }
                            .onDisappear {
                                AlertKitAPI.dismissAllAlerts()
                            }
                    }
                }
                .background {
                    if isLiteMode {
                        Color("Background").ignoresSafeArea()
                    } else {
                        
                    Image("Blob 1")
                        .offset(x: -180, y: 300)
                        .opacity(0.5)
                    Color.clear
                        .background(.regularMaterial)
                    }
                }
                .padding(.bottom, 50)
                .navigationTitle("Fahrtenbuch")
                .searchable(text: $searchString)
                
                //            .onChange(of: model.showDetail, { oldValue, newValue in
                //                withAnimation {
                //                    model.showTab.toggle()
                //                    model.showNav.toggle()
                //                    showStatusBar.toggle()
                //                }
                //            })
                
                .onChange(of: model.lastAddedEntry, { oldValue, newValue in
                    Task {
                        await logbooksVM.refreshTask()
                    }
                })
        }
        .statusBar(hidden: model.showDetail)
        .task(id: logbooksVM.lastListRefresh, logbooksVM.loadFirstPage)
    }
    
    
    @Sendable
    private func loadTask() async {
        await logbooksVM.loadNextPage()
    }
    
    private var filteredLogbooks: [LogbookEntry] {
        if (searchString.isEmpty) {
            return logbooks
        }
        return logbooks.filter {
            return $0.driver.rawValue.lowercased().contains(searchString.lowercased()) || $0.reason.lowercased().contains(searchString.lowercased()) || $0.date.getHumanReadableDayString().contains(searchString.lowercased())
        }
    }
    
    private var logbooks: [LogbookEntry] {
        if case let .success(logbooks) = logbooksVM.phase {
            return logbooks
        } else {
            return logbooksVM.phase.value ?? logbooksVM.loadedLogbooks
        }
    }
}

#Preview {
//    NewListView(logbooks: LogbookEntry.previewData.data)
        NewListView()
        .environmentObject(Model())
//        .environmentObject(NetworkReachability())
        .environmentObject(LogbooksViewModel())
}
