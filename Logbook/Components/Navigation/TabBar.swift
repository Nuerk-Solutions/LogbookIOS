//
//  TabBar.swift
//  Logbook
//
//  Created by Thomas on 27.05.22.
//

import SwiftUI

struct TabBar: View {
    
    
    @State var color: Color = .teal
    @State var selectedX: CGFloat = 0
    @State var x: [CGFloat] = [0, 0, 0, 0]
    
    @AppStorage("selectedTab") var selectedTab: Tab = .home
    @AppStorage("isAllowLocationTracking") var isAllowLocationTracking = false
    @EnvironmentObject var model: Model
    
    var body: some View {
        GeometryReader { proxy in
            let hasHomeIndicator = proxy.safeAreaInsets.bottom > 0
            
            HStack {
                content
                    .zIndex(20)
                    .transition(.move(edge: .trailing))
            }
            .padding(.bottom, hasHomeIndicator ? 16 : 0)
            .frame(maxWidth: .infinity, maxHeight: hasHomeIndicator ? 88 : 49)
            .background(.ultraThinMaterial)
            .background(
                Circle()
                    .fill(color)
                    .offset(x: selectedX, y: -10)
                    .frame(width: 88)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .zIndex(4)
            )
            .overlay(
                Rectangle()
                    .frame(width: 28, height: 5)
                    .cornerRadius(3)
                    .frame(width: 88)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .offset(x: selectedX)
                    .blendMode(.overlay)
            )
            .backgroundStyle(cornerRadius: hasHomeIndicator ? 20 : 0)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea()
            .offset(y: model.showTab ? 0 : 200)
            .accessibility(hidden: !model.showTab)
        }
    }
    
    var content: some View {
        ForEach(Array(tabItems.filter { if !isAllowLocationTracking {
            return $0.selection != .gasStations
        }
            return true
        }.enumerated()), id: \.offset) { index, tab in
            if index == 0 { Spacer() }
            
            Button {
                
                //                try? tab.icon.setInput("active", value: true)
                //                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                //                    try? tab.icon.setInput("active", value: false)
                //                }
                withAnimation(.tabSelection) {
                    selectedTab = tab.selection
                    selectedX = x[index]
                    color = tab.color
                }
            } label: {
                VStack(spacing: 0) {
                    Image(systemName: tab.icon)
                        .symbolVariant(.fill)
                        .font(.system(size: 17, weight: .bold))
                        .frame(width: 44, height: 29)
                    //                    tab.icon.view()
                    //                        .frame(width: 36, height: 36)
                    //                        .frame(maxWidth: .infinity)
                    Text(tab.name).font(.caption2)
                        .frame(width: 88)
                        .lineLimit(1)
                }
                .overlay(
                    GeometryReader { proxy in
                        let offset = proxy.frame(in: .global).minX
                        Color.clear
                            .preference(key: TabPreferenceKey.self, value: offset)
                            .onPreferenceChange(TabPreferenceKey.self) { value in
                                x[index] = value
                                if selectedTab == tab.selection {
                                    selectedX = x[index]
                                }
                            }
                    }
                )
            }
            .frame(width: 44)
            .foregroundColor(selectedTab == tab.selection ? .primary : .secondary)
            .blendMode(selectedTab == tab.selection ? .overlay : .normal)
            
            Spacer()
        }
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
            .environmentObject(Model())
            .previewInterfaceOrientation(.landscapeRight)
            .preferredColorScheme(.light)
    }
}
