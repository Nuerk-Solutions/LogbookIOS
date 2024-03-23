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
    @EnvironmentObject var nAIM: NetworkActivityIndicatorManager
    
    @AppStorage("isLiteMode") private var isLiteMode: Bool = false
    
    
    var body: some View {
        NavigationStack {
            ListContent(logbooks: [])
                .refreshable(action: logbooksVM.refreshTask)
                .sensoryFeedback(.impact, trigger: logbooksVM.lastListRefresh)
                .overlay {
                    if  logbooksVM.isFetchingNextPage || nAIM.isVisible {
                        ZStack{}
                            .onAppear {
                                showSpinningAlert(title: "Laden...")
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
                .navigationTitle("Fahrtenbuch")
                .searchable(text: $searchString)
                .onChange(of: model.showDetail, { oldValue, newValue in
                    withAnimation {
                        showStatusBar.toggle()
                    }
                })
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        AddLogbookButton()
                    }
                }
        }
        .statusBar(hidden: !showStatusBar)
        .task(id: logbooksVM.lastListRefresh, logbooksVM.loadFirstPage)
        .onAppear {
            logbooksVM.lastListRefresh = Int(Date().timeIntervalSince1970)
        }
    }
    
    
    private func loadTask() async {
        await logbooksVM.loadNextPage()
    }
    
    private var filteredLogbooks: [LogbookEntry] {
        if (searchString.isEmpty) {
            return logbooksVM.loadedLogbooks
        }
        return logbooksVM.loadedLogbooks.filter {
            return $0.driver.rawValue.lowercased().contains(searchString.lowercased()) || $0.reason.lowercased().contains(searchString.lowercased()) || $0.date.getHumanReadableDayString().contains(searchString.lowercased())
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
