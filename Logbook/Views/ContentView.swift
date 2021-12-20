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
    
    @StateObject var viewModel = LogbookViewModel()
    var body: some View {
        ZStack {
            LogbookView(latestLogbooks: $viewModel.latestLogbooks, currentLogbook: $viewModel.currentLogbook).environmentObject(self.viewModel)
        }
        .overlay(content: {
            LoadingView(isLoading: $viewModel.isLoading, loadingPhase: $loadingPhase).environmentObject(self.viewModel)
        })
        .onChange(of: viewModel.isLoading, perform: { newValue in
            if(!newValue && !viewModel.showAlert) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        loadingPhase = .none
                    }
                }
            }
        })
        .onChange(of: scenePhase) { newPhase in
            switch newPhase {
            case .inactive:
                loadingPhase = .image
                break;
            case .background:
                loadingPhase = .animation
                return
            case .active:
                loadingPhase = .animation
                viewModel.fetchLatestLogbooks()
            @unknown default:
                loadingPhase = .failed
            }
        }
    }
    
    func getImageURL() -> URL {
        let bundle = Bundle.main.path(forResource: "Car_load", ofType: "gif")
        let url = URL(fileURLWithPath: bundle ?? "")
        
        return url
    }
}

enum LoadingPhase {
    case image
    case animation
    case none
    case failed
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
