//
//  ListContent.swift
//  Logbook
//
//  Created by Thomas Nürk on 15.02.24.
//

import SwiftUI

struct ListContent: View {
    
    @Namespace var namespace
    var logbooks: [LogbookEntry]
    @EnvironmentObject private var logbooksVM: LogbooksViewModel
    @State private var showDetails: Bool = false
    
    var body: some View {
        if logbooksVM.loadedLogbooks.isEmpty {
            GeometryReader { geometry in                    // Get the geometry
                ScrollView(.vertical) {
                    EmptyPlaceholderView(text: "Keine Einträge")
                    .frame(width: geometry.size.width)      // Make the scroll view full-width
                    .frame(minHeight: geometry.size.height) // Set the content’s min height to the parent
                }
            }
        } else {
            List {
                ForEach(logbooksVM.loadedLogbooks, id: \._id) { item in
                    NavigationLink {
                        EntryView(namespace: namespace, entry: item)
                    } label: {
                        EntryItem(entry: item)
                    }
                    .listRowBackground(Color.clear)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        if(logbooksVM.loadedLogbooks.first == item) {
                            Button("", systemImage: "trash", role: .destructive) {
                                // TODO: Fix logic & animation here; remove delay if possible
                                // May rework the VM to handle the animation better; refetch the list automatically after delete
                                // I think to get a smooth animation, we need to to first remove the element and then replace the list; maybe it works with just the list replacement -> TEST THIS
                                
                                // Info: I dont know if this above is relevant after all
                                Task {
                                    await logbooksVM.deleteEntry(logbook: item)
                                }
                            }
                        }
                        Button("", systemImage: "pencil") {
                            showDetails.toggle()
                        }
                    }
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .sheet(isPresented: $showDetails, content: {
                Text("Test")
            })
        }
    }
    //    var scrollDetection: some View {
    //        GeometryReader { proxy in
    //            let offset = proxy.frame(in: .named("scroll")).minY
    //            Color.red.preference(key: ScrollPreferenceKey.self, value: offset)
    //                .frame(width: 0, height: 1)
    //        }
    //        .onPreferenceChange(ScrollPreferenceKey.self) { value in
    //            print(value)
    //            withAnimation(.snappy) {
    //                if value < 0 {
    //                    contentHasScrolled = true
    //                    print("TRUE")
    //                } else {
    //                    contentHasScrolled = false
    //                    print("FALSE")
    //                }
    //            }
    //        }
    //    }
}

#Preview {
    ListContent(logbooks: LogbookEntry.previewData.data)
}
