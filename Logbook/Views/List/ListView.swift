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
import RealmSwift

struct ListView: View {
    
    @ObservedResults(logbook.self, sortDescriptor: SortDescriptor.init(keyPath: "date", ascending: false)) private var logbooks
    
    private var columns = [GridItem(.adaptive(minimum: 300), spacing: 20)]
    @State var contentHasScrolled = false
    @State var scrollViewOffset: CGFloat = 0
    @State var showStatusBar = true
    
    @EnvironmentObject var model: Model
    
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
    init() {
        UITableView.appearance().backgroundColor = .clear // For tableView
        UITableViewCell.appearance().backgroundColor = .clear // For tableViewCell
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
        
        .onChange(of: model.showDetail) { value in
            withAnimation {
                model.showTab.toggle()
                model.showNav.toggle()
                showStatusBar.toggle()
            }
        }
        .statusBar(hidden: !showStatusBar)
    }
    
    @ViewBuilder
    var detail: some View {
        ForEach(logbooks) { entry in
            if entry._id.stringValue == model.selectedEntry.stringValue {
                EntryView(namespace: namespace, entry: .constant(entry))
            }
        }
    }
    
    @ViewBuilder
    var content: some View {
//        ScrollView {
//            scrollDetection
            
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
            
            entry
//                .padding(.top, 70)
//                .padding(.bottom, 120)
                .id("SCROLL_TO_TOP")
            
//        }
//        .coordinateSpace(name: "scroll")
    }
    
    @ViewBuilder
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
                        .padding(.horizontal, 15)
                }
            }
        }
    }
    
    @ViewBuilder
    var entry: some View {
        GeometryReader { proxy in
            let offset = proxy.frame(in: .named("scroll")).minY
        List {
            Text("")
                .listRowBackground(Color.clear)
                .transformAnchorPreference(key: MyKey.self, value: .bounds) {
                                        $0.append(MyFrame(id: "tableTopCell", frame: proxy[$1]))
                                    }
//            }

            ForEach(logbooks) { entry in
//                if entry == logbooks.last {
//                    EntryItem(namespace: namespace, entry: entry)
//                        .accessibilityElement(children: .combine)
//                        .accessibilityAddTraits(.isButton)
//                        .transition(.opacity)
//                } else {
                    EntryItem(namespace: namespace, entry: entry)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .accessibilityElement(children: .combine)
                        .accessibilityAddTraits(.isButton)
                        .transition(.opacity)
                        .contextMenu {
                            Button {
                                print("Edited")
                            } label: {
                                Label {
                                    Text("Bearbeiten")
                                } icon: {
                                    Image(systemName: "pencil")
                                }
                            }
                            if entry == logbooks.first {
                                Button {
                                    // Remove logic
                                } label: {
                                    Label {
                                        Text("Löschen")
                                    } icon: {
                                        Image(systemName: "trash")
                                    }
                                }
//                            }
                        }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .listSectionSeparator(.hidden)
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
        }
        .background(
            Image("Blob 1")
                .offset(x: -180, y: 300)
                .opacity(0.5))
        }
        .scrollContentBackground(.hidden)
        .onPreferenceChange(MyKey.self) {
            if(!$0.isEmpty) {
                    if($0[0].frame.minY < 30) {
                        withAnimation {
                        contentHasScrolled = true
                        }
                    } else {
                        withAnimation {
                            contentHasScrolled = false
                        }
                }
            }
        }
    }
}
struct MyFrame : Equatable {
    let id : String
    let frame : CGRect

    static func == (lhs: MyFrame, rhs: MyFrame) -> Bool {
        lhs.id == rhs.id && lhs.frame == rhs.frame
    }
}

struct MyKey : PreferenceKey {
    typealias Value = [MyFrame] // The list of view frame changes in a View tree.

    static var defaultValue: [MyFrame] = []

    /// When traversing the view tree, Swift UI will use this function to collect all view frame changes.
    static func reduce(value: inout [MyFrame], nextValue: () -> [MyFrame]) {
        value.append(contentsOf: nextValue())
    }
}
