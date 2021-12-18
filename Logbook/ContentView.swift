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
    
    @State private var currentLogbook = Logbook(driver: .Andrea, vehicle: Vehicle(typ: .Ferrari, currentMileAge: 0, newMileAge: 0), date: Date(), driveReason: "Stadtfahrt", additionalInformation: nil)
    @State private var lastLogbooks: [Logbook] = []
    
    @Environment(\.scenePhase) var scenePhase
    
    @StateObject var viewModel = LogbookViewModel()
    
    
    var body: some View {
        ZStack {
            LogbookView()
        }
        .overlay(content: {
            LoadingView(isLoading: $viewModel.isLoading, loadingPhase: $loadingPhase)
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
        }.onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                if(viewModel.isLoading) {
                    viewModel.fetchLatestLogbooks()
                }
            }
        })
        .alert(Text("Application Error"), isPresented: $viewModel.showAlert, actions: {
            Button("OK") {}
        }, message: {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
            }
        })
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
