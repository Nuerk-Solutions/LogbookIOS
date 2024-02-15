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
}

#Preview {
    ListContent(logbooks: LogbookEntry.previewData.data)
}
