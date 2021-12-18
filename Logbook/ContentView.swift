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
        .onChange(of: scenePhase) { newPhase in
            switch newPhase {
            case .active:
                // Delay management
//                if(!viewModel.isLoading) {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                        loadingPhase = .animation
//                        viewModel.fetchLatestLogbooks()
//                    }
//                }
                break
            case .inactive, .background:
                loadingPhase = .image
                viewModel.isLoading = true
                break
            default:
                loadingPhase = .image
            }
        }.onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                if(viewModel.isLoading) {
                    viewModel.fetchLatestLogbooks()
                }
            }
        })
            .alert("Application Error", isPresented: $viewModel.showAlert, actions: {
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
