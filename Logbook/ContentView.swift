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
    
    @State private var animate = true
    @State private var isLoading = true
    @State private var isInactive = false
    @State private var removeGif = false
    
    @State private var currentLogbook = Logbook(driver: .Andrea, vehicle: Vehicle(typ: .Ferrari, currentMileAge: 0, newMileAge: 0), date: Date(), driveReason: "Stadtfahrt", additionalInformation: nil)
    @State private var lastLogbooks: [Logbook] = []
    
    
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        ZStack {
            Color("BG")
                .ignoresSafeArea(.all, edges: .all)
                .zIndex(0)
            
            if(isInactive) {
                Color("BG")
                    .ignoresSafeArea(.all, edges: .all)
                    .zIndex(0)
                Image("logo")
                    .ignoresSafeArea(.all, edges: .all)
                    .scaledToFit()
                    .frame(width: 400, height: 400)
                    .zIndex(1)
            } else if animate {
                Color("BG")
                    .ignoresSafeArea(.all, edges: .all)
                    .zIndex(0)
                    .transition(AnyTransition.iris.combined(with: .opacity.animation(.easeInOut(duration: 0.5))))
                AnimatedImage(url: getImageURL())
                    .playbackRate(1.2)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 400, height: 400)
                    .zIndex(1)
            } else {
                MainView(currentLogbook: $currentLogbook, lastLogbooks: $lastLogbooks)
            }
        }
        .onChange(of: isLoading) { newState in
            if(!newState) {
                animateCircle()
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if(newPhase == .inactive) {
                isInactive = true
                animate = true
                isLoading = true
                return
            }
            if(newPhase == .background) {
                isInactive = false
                animate = true
                isLoading = true
                return
            }
            isInactive = false
            Api().getLogbookEntries{(logbooks, error)  in
                if(error == nil) {
                    self.lastLogbooks = logbooks!
                    
                    let currentMilAge = currentLogbook.vehicle.typ == VehicleEnum.VW ? lastLogbooks[0].vehicle.currentMileAge : lastLogbooks[1].vehicle.currentMileAge
                    
                    currentLogbook.vehicle = Vehicle(typ: currentLogbook.vehicle.typ == VehicleEnum.VW ? .VW : .Ferrari, currentMileAge: currentMilAge, newMileAge: currentMilAge + 1)
                    isLoading = false
                    print("Fetch in UI Sucessfully")
                } else {
                    if(error! as! HttpError == HttpError.statusNot200) {
                        print("Alert!")
                    }
                }
                
            }
        }
    }
    
    
    func animateCircle() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.15) {
            withAnimation(.easeInOut(duration: 0.3)) {
                animate = false
                print("Animated")
            }
        }
    }
    
    func getImageURL() -> URL {
        let bundle = Bundle.main.path(forResource: "Car_load", ofType: "gif")
        let url = URL(fileURLWithPath: bundle ?? "")
        
        return url
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
