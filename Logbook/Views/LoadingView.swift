//
//  LoadingView.swift
//  Logbook
//
//  Created by Thomas on 18.12.21.
//

import SwiftUI
import SDWebImageSwiftUI
import SPAlert

struct LoadingView: View {
    
    @Binding var isLoading: Bool
    @Binding var loadingPhase: LoadingPhase
    @EnvironmentObject var viewModel: LogbookViewModel
    
    var body: some View {
        ZStack {
            if(loadingPhase == .image) {
                ZStack {
                    Color("BG")
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 400, height: 300)
                }
                .edgesIgnoringSafeArea(.all)
                .zIndex(1)
            } else if loadingPhase == .animation {
                ZStack {
                    Color("BG")
                    // Needed for some reason, to hide initial animation of AnimatedImage
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 400, height: 300)
                    
                    AnimatedImage(url: getImageURL())
                        .playbackRate(1.2)
                        .scaledToFit()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 400, height: 300)
                }
                .edgesIgnoringSafeArea(.all)
                .zIndex(1)
                .transition(.iris)
            }
        }.spAlert(isPresent: $viewModel.showAlert,
                  message: viewModel.errorMessage ?? "",
                  duration: 10.0,
                  dismissOnTap: false,
                  preset: SPAlertIconPreset.error,
                  haptic: .error,
                  completion: {
            viewModel.fetchLatestLogbooks()
        })
    }
    
    func getImageURL() -> URL {
        let bundle = Bundle.main.path(forResource: "Car_load", ofType: "gif")
        let url = URL(fileURLWithPath: bundle ?? "")
        
        return url
    }
}

//struct LoadingView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoadingView()
//    }
//}
