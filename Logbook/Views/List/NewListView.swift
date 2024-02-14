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
    @Namespace private var namespace
    
    @EnvironmentObject var model: Model
    @EnvironmentObject var networkReachablility: NetworkReachability
    @EnvironmentObject var logbooksVM: LogbooksViewModel
    @StateObject private var netWorkActivitIndicatorManager = NetworkActivityIndicatorManager()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredLogbooks, id: \._id) { item in
                    if(item == logbooks.last && searchString.isEmpty) {
                        EntryItem(namespace: namespace, entry: item)
                            .listRowBackground(Color("Background").ignoresSafeArea())
                            .task(id: logbooksVM.lastListRefresh, loadTask)
                    } else {
                        EntryItem(namespace: namespace, entry: item)
                            .listRowBackground(Color("Background").ignoresSafeArea())
                    }
                }
                
            }
            .padding(.bottom, 50)
            .background(Color("Background").ignoresSafeArea())
            .overlay {
                if  logbooksVM.isFetchingNextPage || netWorkActivitIndicatorManager.isNetworkActivityIndicatorVisible {
                    ZStack{}
                        .onAppear {
                        AlertKitAPI.present(
                                  title: "Laden...",
                                  icon: .spinnerSmall,
                                  style: .iOS17AppleMusic,
                                  haptic: AlertHaptic.warning
                              )
                    }
                        .onDisappear {
                            AlertKitAPI.dismissAllAlerts()
                        }
                }
            }
            .scrollContentBackground(.hidden)
            .listStyle(.plain)
            .navigationTitle("Fahrtenbuch")
            .searchable(text: $searchString)
            .statusBarHidden(!showStatusBar)
            
            .onChange(of: model.showDetail, { oldValue, newValue in
                withAnimation {
                    model.showTab.toggle()
                    model.showNav.toggle()
                    showStatusBar.toggle()
                }
            })
            
            .onChange(of: model.lastAddedEntry, { oldValue, newValue in
                refreshTask()
            })
        }
        .task(id: logbooksVM.lastListRefresh, loadFirstTask)
    }
    
    @Sendable
    private func loadFirstTask() async {
        await logbooksVM.loadFirstPage(connected: networkReachablility.connected)
    }
    
    private func refreshTask() {
        Task {
            await logbooksVM.refreshTask()
        }
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
        .environmentObject(NetworkReachability())
        .environmentObject(LogbooksViewModel())
}
