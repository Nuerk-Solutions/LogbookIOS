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
    
    var body: some View {
        List {
            ForEach(logbooks, id: \._id) { item in
                NavigationLink {
                    EntryView(namespace: namespace, entry: item)
                } label: {
                    EntryItem(namespace: namespace, entry: item)
                }
                .listRowBackground(Color.clear)
            }
        }
        .coordinateSpace(name: "scroll")
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
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
