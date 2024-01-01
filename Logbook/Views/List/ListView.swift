//
//  ListView.swift
//  Logbook
//
//  Created by Thomas on 26.05.22.
//

import Foundation

import SwiftUI
import SwiftUI_Extensions
import Alamofire
import UIKit

struct ListView: View {
    
    var columns = [GridItem(.adaptive(minimum: 300), spacing: 20)]
    @State var contentHasScrolled = false
    @State var scrollViewOffset: CGFloat = 0
    @State var showStatusBar = true
    
    //    @Binding var showAdd: Bool
    @Binding var lastRefreshDate: Date?
    
    @EnvironmentObject var model: Model
    @EnvironmentObject var networkReachablility: NetworkReachability
    
    @StateObject var logbooksVM: LogbooksViewModel
    @Namespace var namespace
    let deleteAction = UIAction(
        title: "Delete",
        image: UIImage(systemName: "delete.left"),
        identifier: nil,
        attributes: UIMenuElement.Attributes.destructive,
        handler: { _ in print("Deleted") }
    )
    
    
    let mediumDateAndTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "de_DE")
        return formatter
    }()
    
    init(logbooks: [LogbookEntry]? = nil, showAdd: Binding<Bool>, lastRefreshDate: Binding<Date?>) {
        self._logbooksVM = StateObject(wrappedValue: LogbooksViewModel(logbooks: logbooks))
        //        self._showAdd = showAdd
        self._lastRefreshDate = lastRefreshDate
    }
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            if model.showDetail {
                detail
            }
            content
                .background(
                    Image("Blob 1")
                        .offset(x: -180, y: 300)
                        .opacity(0.5))
        }
        .overlay(NavigationBar(title: "Fahrtenbuch", contentHasScrolled: $contentHasScrolled))
        .overlay(overlayView)
        
        .onChange(of: model.showDetail) { value in
            withAnimation {
                model.showTab.toggle()
                model.showNav.toggle()
                showStatusBar.toggle()
            }
        }
        .onChange(of: model.lastAddedEntry, perform: { newValue in
            refreshTask()
        })
        .statusBar(hidden: !showStatusBar)
    }
    
    var detail: some View {
        ForEach(logbooks) { entry in
            if entry.id == model.selectedEntry {
                EntryView(namespace: namespace, entry: .constant(entry))
            }
        }
    }
    
    var content: some View {
        ScrollView {
            scrollDetection
            
            //            HStack {
            //                Text("Letzte Aktualisierung: \(mediumDateAndTime.string(from: Date(timeIntervalSince1970: TimeInterval(logbooksVM.lastListRefresh))))")
            //                    .font(.footnote.weight(.medium))
            //                    .transition(.identity.animation(.linear(duration: 1).delay(2)))
            //
            //                if logbooksVM.phase == .empty{
            //                    ProgressView()
            //                        .padding(.horizontal, 5)
            //                } else {
            //                    if(networkReachablility.connected) {
            //                        Button {
            //                            Task {
            //                                await logbooksVM.loadFirstPage(connected: networkReachablility.connected)
            //                            }
            //                        } label: {
            //                            Image(systemName: "arrow.counterclockwise.circle")
            //                                .resizable()
            //                                .frame(width: 20, height: 20)
            //                                .rotationEffect(Angle(degrees: -90))
            //                                .symbolRenderingMode(.hierarchical)
            //                        }
            //                    } else {
            //                        EmptyView()
            //                    }
            //                }
            //            }
            //            .frame(maxWidth: .infinity, alignment: .topLeading)
            //            .padding(.horizontal, 21)
            //            .padding(.top, 50)
            
            entrySection2
                .padding(.top, 70)
                .padding(.bottom, 120)
                .id("SCROLL_TO_TOP")
            
        }
        .task(id: logbooksVM.lastListRefresh, loadFirstTask)
        .coordinateSpace(name: "scroll")
        .onReceive(networkReachablility.$connected) { newValue in
            if !networkReachablility.connected && newValue {
                Task {
                    await logbooksVM.loadFirstPage(connected: newValue)
                }
            }
        }
        .onReceive(logbooksVM.$phase, perform: { newValue in
            withAnimation {
                model.showDetail = false
            }
        })
    }
    
    @ViewBuilder
    private var overlayView: some View {
        switch logbooksVM.phase {
            //        case .empty:
            //            CustomProgressView(message: "Fetching Logbooks")
        case .success(let logbooks) where logbooks.isEmpty:
            EmptyPlaceholderView(text: "Keine Einträge vorhanden")
        case .failure(let error):
            RetryView(text: error.localizedDescription, retryAction: refreshTask)
        default: EmptyView()
        }
    }
    
    private var logbooks: [LogbookEntry] {
        if case let .success(logbooks) = logbooksVM.phase {
            return logbooks
        } else {
            return logbooksVM.phase.value ?? logbooksVM.loadedLogbooks
        }
    }
    
    
    @Sendable
    private func loadFirstTask() async {
        let lastRefresh: TimeInterval = (lastRefreshDate?.timeIntervalSinceReferenceDate ?? 99)
        let canFetch = Date().timeIntervalSinceReferenceDate - lastRefresh > 60 || model.lastAddedEntry.timeIntervalSinceReferenceDate - lastRefresh < 60 || logbooksVM.phase.value == nil
        if canFetch {
            lastRefreshDate = Date()
        }
        await logbooksVM.loadFirstPage(connected: networkReachablility.connected && canFetch)
    }
    
    @Sendable
    private func loadTask() async {
        await logbooksVM.loadNextPage()
    }
    
    
    private func refreshTask() {
        Task {
            await logbooksVM.refreshTask()
        }
    }
    
    var entrySection2: some View {
        Group {
            if model.showDetail {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(logbooks) { entry in
                        Rectangle()
                            .fill(.regularMaterial)
                            .frame(height: 50)
                            .cornerRadius(30)
                            .shadow(color: Color("Shadow").opacity(0.2), radius: 20, x: 0, y: 10)
                            .opacity(0.3)
                    }
                }
                .padding(.horizontal, 20)
                .offset(y: -80)
            } else {
                LazyVGrid(columns: columns, spacing: 15) {
                    entry
                    
                    //                        .frame(height: 50)
                        .padding(.horizontal, 15)
                    //                        .shadow(radius: 0.5)
                    //                        .padding(.vertical, 5)
                    
                    if logbooksVM.isFetchingNextPage {
                        CustomProgressView(message: "Laden...")
                        //                            .offset(y: -40)
                    }
                }
                //                .padding(.horizontal, 20)
                .opacity(logbooksVM.logbooksOpacity)
            }
        }
    }
    
    var entry: some View {
        
        ForEach(logbooks) { entry in
            if entry == logbooks.last {
                EntryItem(namespace: namespace, entry: entry)
                    .accessibilityElement(children: .combine)
                    .accessibilityAddTraits(.isButton)
                    .task(id: logbooksVM.lastListRefresh, loadTask)
                    .transition(.opacity)
            } else {
                EntryItem(namespace: namespace, entry: entry)
                    .accessibilityElement(children: .combine)
                    .accessibilityAddTraits(.isButton)
                    .transition(.opacity)
                    .contextMenu {
//                        Button {
//                            print("Edited")
//                        } label: {
//                            Label {
//                                Text("Bearbeiten")
//                            } icon: {
//                                Image(systemName: "pencil")
//                            }
//                        }
                        if entry == logbooks.first {
                            Button {
                                Task {
                                    await logbooksVM.deleteEntry(connected: networkReachablility.connected, logbook: entry)
                                    
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            logbooksVM.loadedLogbooks.removeFirst()
                                            logbooksVM.phase = .success(logbooksVM.loadedLogbooks)
                                        }
                                    // Refresh Task will execute immidiate, because it does not await the DispatchQueue
//                                    await logbooksVM.refreshTask()
                                }
                            } label: {
                                Label {
                                    Text("Löschen")
                                } icon: {
                                    Image(systemName: "trash")
                                }
                            }
                        }
                    }
            }
        }
    }
    
    
    var scrollDetection: some View {
        GeometryReader { proxy in
            let offset = proxy.frame(in: .named("scroll")).minY
            Color.clear.preference(key: ScrollPreferenceKey.self, value: offset)
        }
        .onPreferenceChange(ScrollPreferenceKey.self) { value in
            withAnimation(.easeInOut) {
                if value < 0 {
                    contentHasScrolled = true
                } else {
                    contentHasScrolled = false
                }
            }
        }
    }
}

//struct ListView_Previews: PreviewProvider {
//    
//    static var previews: some View {
//        ListView(logbooks: LogbookEntry.previewData, showAdd: .constant(false), lastRefreshDate: .constant(Date()))
//            .environmentObject(Model())
//            .environmentObject(NetworkReachability())
//    }
//}
