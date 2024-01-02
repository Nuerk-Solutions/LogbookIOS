//
//  NavigationBar.swift
//  Logbook
//
//  Created by Thomas on 29.05.22.
//

import SwiftUI

struct NavigationBar: View {
    
    var title = ""
    
//    @Binding var showSheet: Bool
    @Binding var contentHasScrolled: Bool
    
    @EnvironmentObject var model: Model
    @StateObject private var netWorkActivitIndicatorManager = NetworkActivityIndicatorManager()
    @EnvironmentObject var networkReachablility: NetworkReachability
    @AppStorage("isLogged") var isLogged = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(maxWidth: .infinity)
                .frame(height: 100)
                .background(.ultraThinMaterial)
                .ignoresSafeArea()
                .frame(maxHeight: .infinity, alignment: .top)
                .blur(radius: contentHasScrolled ? 10 : 0)
                .opacity(contentHasScrolled ? 1 : 0)
            
            Text(title)
                .animatableFont(size: contentHasScrolled ? 22 : 34, weight: .bold)
                .foregroundStyle(colorScheme == .dark ? (contentHasScrolled ? .black : .white) : (contentHasScrolled ? .white : .black))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .opacity(contentHasScrolled ? 0.7 : 1)
            
            HStack(spacing: 16) {
                
                if netWorkActivitIndicatorManager.isNetworkActivityIndicatorVisible {
                    ProgressView()
                }
                
                
//                    Image(systemName: "doc.badge.plus")
//                        .symbolRenderingMode(.multicolor)
//                        .font(.system(size: 17, weight: .bold))
//                        .frame(width: 40, height: 40)
//                        .foregroundColor(.secondary)
//                        .background(.ultraThickMaterial)
//                        .backgroundStyle(cornerRadius: 16, opacity: 0.4)
//                        .onTapGesture {
//                            
//                                                withAnimation(.spring()) {
//                            //                        showSheet.toggle()
//                                                    model.showAdd.toggle()
//                                                    model.showTab.toggle()
//                                                }
//                        }
                
                Button {
                    if(networkReachablility.reachable && networkReachablility.connected){
                        withAnimation(.spring()) {
                            //                        showSheet.toggle()
                            model.showAdd.toggle()
//                            model.showTab.toggle()
                        }
                    }
                } label: {
                    if(networkReachablility.reachable && networkReachablility.connected) {
                        Image(systemName: "doc.badge.plus")
                            .resizable()
                            .scaledToFit()
                            .symbolRenderingMode(.multicolor)
                            .font(.system(size: 17, weight: .bold))
                            .frame(width: 28, height: 28)
                            .foregroundColor(.secondary)
                            .padding(10)
                            .background(.regularMaterial)
                            .backgroundStyle(cornerRadius: 16, opacity: 0.4)
                            .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 10)
                    } else {
                        Image(systemName: "wifi.exclamationmark")
                            .resizable()
                            .scaledToFit()
                            .symbolRenderingMode(.palette)
                            .symbolEffect(.pulse.byLayer, options: .repeating)
                            .foregroundStyle(.primary, .red)
                            .frame(width: 32, height: 32)
                            .padding(10)
                            .background(.regularMaterial)
                            .backgroundStyle(cornerRadius: 16, opacity: 0.4)
                            .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 10)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .padding()
            
        }
//        .onChange(of: showSheet, perform: { newValue in
//            withAnimation {
//                model.showTab.toggle()
//            }
//        })
        .offset(y: model.showNav ? 0 : -120)
        .accessibility(hidden: !model.showNav)
        .offset(y: contentHasScrolled ? -16 : 0)
    }
}

struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBar(title: "TEST",  contentHasScrolled: .constant(false))
            .preferredColorScheme(.dark)
            .previewInterfaceOrientation(.landscapeRight)
            .environmentObject(Model())
    }
}
