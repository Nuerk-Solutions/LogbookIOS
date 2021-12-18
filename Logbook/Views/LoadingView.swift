//
//  LoadingView.swift
//  Logbook
//
//  Created by Thomas on 18.12.21.
//

import SwiftUI
import SDWebImageSwiftUI

struct LoadingView: View {
    
    //@Binding var animate: Bool
    //@Binding var isInactive: Bool
    @Binding var isLoading: Bool
    @Binding var loadingPhase: LoadingPhase
    
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
                if(isLoading) {
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
                    .transition(.iris.animation(.easeInOut(duration: 0.3)))
                }
            }
        }
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
