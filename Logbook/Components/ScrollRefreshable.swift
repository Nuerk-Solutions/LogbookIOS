//
//  ScrollRefreshable.swift
//  Logbook
//
//  Created by Thomas on 07.06.22.
//

import SwiftUI

struct ScrollRefreshable<Content: View>: View {
    
    var content: Content
    var onRefresh: @Sendable () async -> Void
    
    init(title: String, tintColor: Color, @ViewBuilder content: @escaping () -> Content, onRefresh: @escaping @Sendable () async -> Void) {
        self.content = content()
        self.onRefresh = onRefresh
        
        UIRefreshControl.appearance().attributedTitle = NSAttributedString(string: title)
        UIRefreshControl.appearance().tintColor = UIColor(tintColor)
    }
    
    var body: some View {
        List {
            content
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
                .ignoresSafeArea(.all, edges: .all)
        }
        .safeAreaInset(edge: .top, content: {
            Color.clear.frame(height: 50)
        })
        .listStyle(.plain)
        .refreshable {
            await onRefresh()
        }
    }
}
