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
    @State private var removeGif = true
    @State private var showingAlert = false
    
    @State private var currentLogbook = Logbook(driver: .Andrea, vehicle: Vehicle(typ: .Ferrari, currentMileAge: 0, newMileAge: 0), date: Date(), driveReason: "Stadtfahrt", additionalInformation: nil)
    @State private var lastLogbooks: [Logbook] = []
    
    
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        ZStack {
            Color("BG")
                .ignoresSafeArea(.all, edges: .all)
                .zIndex(0)
            MainView(currentLogbook: $currentLogbook, lastLogbooks: $lastLogbooks)
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
                    .transition(.iris)
                AnimatedImage(url: getImageURL())
                    .playbackRate(1.2)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 400, height: 400)
                    .zIndex(1)
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
            fetchData()
            
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Verbindungsfehler!"),
                  message: Text("Es konnte keine Verbindung zum Server hergestellt werden"),
                  dismissButton: .default(Text("Erneut Versuchen")){
                fetchData()
            })
        }
    }
    
    func fetchData() {
        getLogbookEntries{(logbooks, error)  in
            if(error == nil) {
                self.lastLogbooks = logbooks!
                
                let currentMilAge = currentLogbook.vehicle.typ == VehicleEnum.VW ? lastLogbooks[0].vehicle.currentMileAge : lastLogbooks[1].vehicle.currentMileAge
                
                currentLogbook.vehicle = Vehicle(typ: currentLogbook.vehicle.typ == VehicleEnum.VW ? .VW : .Ferrari, currentMileAge: currentMilAge, newMileAge: currentMilAge + 1)
                print("Fetch in UI Sucessfully")
            } else {
                if(error! as! HttpError == HttpError.statusNot200) {
                    showingAlert = true
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
    
    func getLogbookEntries(completion: @escaping ([Logbook]?, Error?) -> ()) {
        guard let url = URL(string: "https://api.nuerk-solutions.de/logbook") else { fatalError("Missing URL")} // guard adds a condition. because swift is typesafe you need to be sure to have the right type; if the URL is empty or nil then return the func at that point
        
        let urlRequest = URLRequest(url: url)
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 5
        configuration.waitsForConnectivity = true
        
        let dataTask = URLSession(configuration: configuration).dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                completion(nil, HttpError.statusNot200)
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return  }
            
            if response.statusCode == 200 {
                guard let data = data else { return }
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategyFormatters = [DateFormatter.standardT]
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                DispatchQueue.main.async {
                    do {
                        let logbookEntries = try decoder.decode([Logbook].self, from: data)
                        completion(logbookEntries, nil)
                        animateCircle()
                    } catch let error {
                        print("Error decoding: ", error)
                        completion(nil, HttpError.statusNot200)
                    }
                }
            } else {
                completion(nil, HttpError.statusNot200)
            }
        }
        
        dataTask.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
