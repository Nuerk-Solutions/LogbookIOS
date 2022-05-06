//
//  ContentView.swift
//  Logbook
//
//  Created by Thomas on 01.12.21.
//

import SwiftUI
import Combine
import SDWebImageSwiftUI

struct ContentView: View {
    
    @State private var loadingPhase: LoadingPhase = .animation
    @Environment(\.scenePhase) var scenePhase
    
    @StateObject var listViewModel = ListViewModel()
    var body: some View {
        ZStack {
            TabBar()
        }
        .overlay(content: {
            LoadingView(isLoading: $listViewModel.isLoading, loadingPhase: $loadingPhase).environmentObject(self.listViewModel)
        })
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.15) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    loadingPhase = .none
                }
            }
        }
    }
}

enum LoadingPhase {
    case image
    case animation
    case none
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
