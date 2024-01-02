//
//  AddEntryView.swift
//  Logbook
//
//  Created by Thomas on 28.07.22.
//

import SwiftUI
import UIKit
import Combine

struct AddEntryView: View {
    
    @StateObject var newEntryVM = NewEntryViewModel()
    
    @State var showAddInfoSelection = false
    @State var isLoading = false
    @Binding var show: Bool
    @Binding var showTab: Bool
    @Binding var lastAddedEntry: Date
    @State private var canSubmit = false
    
    @AppStorage("currentDriver") var currentDriver: DriverEnum = .Andrea
    @AppStorage("currentVehicle") var currentVehicle: VehicleEnum = .Ferrari
    
    @EnvironmentObject var networkReachablility: NetworkReachability
    
    @Namespace var namespace
        
    let mediumDateAndTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "de_DE")
        return formatter
    }()
    
    var body: some View {
        ZStack {
            Color("Shadow").ignoresSafeArea()
                .opacity(showAddInfoSelection ? 0.4 : 0)
            
            NavigationStack {
                VStack(alignment: .leading, spacing: 16) {
                    HStack (alignment: .firstTextBaseline, spacing: 0) {
                        Text("Neuer Eintrag")
                            .font(.custom("Poppins Bold", size: 30))
                            .frame(width: 260, alignment: .leading)
                        if newEntryVM.fetchPhase == .fetchingNextPage(lastLogbooks) {
                            ProgressView()
                                .padding(.horizontal, 5)
                        }
                    }
                    
                    DVDComponent(newLogbook: $newEntryVM.newLogbook, lastLogbooks: lastLogbooks)
                    MileAgeComponent(newLogbook: $newEntryVM.newLogbook)
                    DetailsComponent(newLogbook: $newEntryVM.newLogbook)
                    AddInfoButtonComponent(newLogbook: $newEntryVM.newLogbook, showAddInfoSlection: $showAddInfoSelection)
                    EntrySubmitComponent(newLogbook: $newEntryVM.newLogbook)
                }
                .padding(.horizontal, 40)
                .padding(.top, 80)
                .padding(.bottom, 40)
                .background(.ultraThinMaterial)
                .sheet(isPresented: $showAddInfoSelection) {
                    AddInfoSelectComponent(showAddInfoSelection: $showAddInfoSelection, newLogbook: $newEntryVM.newLogbook)
                        .presentationDetents([.fraction(CGFloat(0.45))])
                        .presentationCornerRadius(30)
                        .presentationBackground(.thinMaterial)
                }
                .task {
                    setDefaults(connected: networkReachablility.connected)
                }
                .onReceive(networkReachablility.$connected) { newValue in
                    if !networkReachablility.connected && newValue {
                        setDefaults(connected: newValue)
                    }
                }
                .onReceive(newEntryVM.$fetchPhase) { newValue in
                    DispatchQueue.main.async {
                        updateVehicleData(vehicle: currentVehicle)
                    }
                }
                
                //        .onChange(of: newEntryVM.phase.value ?? [], perform: { newValue in
                //
                //            newEntryVM.newLogbook.currentMileAge = newValue[0].currentMileAge
                //        })
                //        .fixedSize(horizontal: false, vertical: true)
            }
                .offset(y: showAddInfoSelection ? -25 : 0)
            
            Button {
                withAnimation {
                    show.toggle()
                    showTab.toggle()
                }
            } label: {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .frame(width: 36, height: 36)
                    .background(.black)
                    .mask(Circle())
                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 10)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .padding(20)
            .offset(y: showAddInfoSelection ? -10 : 0)
            .opacity(showAddInfoSelection ? 0.2 : 1)
            
        }
    }
    
    private func setDefaults(connected: Bool) {
        Task {
            await newEntryVM.load(connected: connected)
            updateVehicleData(vehicle: currentVehicle)
            newEntryVM.newLogbook.vehicle = currentVehicle
            newEntryVM.newLogbook.driver = currentDriver
        }
    }
    
    private func updateVehicleData(vehicle: VehicleEnum) {
        currentVehicle = vehicle
        newEntryVM.newLogbook.mileAge.current = getLogbookForVehicle(lastLogbooks: lastLogbooks, vehicle: vehicle)?.mileAge.new ?? 0
    }
    
    private var lastLogbooks: [LogbookEntry] {
        switch newEntryVM.fetchPhase {
        case let .success(lastLogbooks):
            return lastLogbooks
        case let .fetchingNextPage(lastLogbooks):
            return lastLogbooks
        default:
            return newEntryVM.fetchPhase.value ?? []
        }
    }
    
}

struct NewAddView_Previews: PreviewProvider {
    static var previews: some View {
        AddEntryView(show: .constant(true), showTab: .constant(false), lastAddedEntry: .constant(Date()))
            .preferredColorScheme(.light)
            .environmentObject(NetworkReachability())
    }
}
