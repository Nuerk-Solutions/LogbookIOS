//
//  AddEntryView.swift
//  Logbook
//
//  Created by Thomas on 28.07.22.
//

import SwiftUI
import UIKit
import Combine
import AlertKit

struct AddEntryView: View {
    
    @StateObject var newEntryVM = NewEntryViewModel()
    
    @State var showAddInfoSelection = false
    @Binding var show: Bool
    @Binding var showTab: Bool
    @Binding var lastAddedEntry: Date
    @State private var canSubmit = false
    
    @AppStorage("currentDriver") var currentDriver: DriverEnum = .Andrea
    
    @EnvironmentObject var networkReachablility: NetworkReachability
    @StateObject private var netWorkActivitIndicatorManager = NetworkActivityIndicatorManager()
    
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
                        if newEntryVM.fetchPhase == .fetchingNextPage(lastLogbooks) || netWorkActivitIndicatorManager.isNetworkActivityIndicatorVisible {
                            ProgressView()
                                .padding(.horizontal, 5)
                        }
                    }
                    
                    DVDComponent(newLogbook: $newEntryVM.newLogbook, lastLogbooks: lastLogbooks)
                    MileAgeComponent(newLogbook: $newEntryVM.newLogbook)
                    HStack {
                        AddInfoButtonComponent(newLogbook: $newEntryVM.newLogbook, showAddInfoSlection: $showAddInfoSelection)
                        DetailsComponent(newLogbook: $newEntryVM.newLogbook)
                    }
                    EntrySubmitComponent()
                        .environmentObject(newEntryVM)
                        .environmentObject(networkReachablility)
                }
                .padding(.horizontal, 20)
                .padding(.top, 80)
//                .padding(.bottom, 40)
                .background(.ultraThinMaterial)
                .sheet(isPresented: $showAddInfoSelection) {
                    AddInfoSelectComponent(showAddInfoSelection: $showAddInfoSelection, newLogbook: $newEntryVM.newLogbook)
                        .presentationDetents([.fraction(CGFloat(0.45))])
                        .presentationCornerRadius(30)
                        .presentationBackground(.thinMaterial)
                }
                .overlay(content: {
                    
                    switch $newEntryVM.sendPhase.wrappedValue {
                    case .sending:
                            CustomProgressView(message: "Senden...")
                        case .failure(let error):
                        EmptyView()
                            .onAppear {
                                print("ERROR DURING SEND!")
                                print(error)
                            AlertKitAPI.present(
                                title: "Fehler beim Speichern!",
                                icon: .error,
                                style: .iOS17AppleMusic,
                                haptic: .error
                            )
                            }
                        case .success:
                        EmptyView()
                            .onAppear {
                                AlertKitAPI.present(
                                    title: "Eintrag hinzugefügt",
                                    icon: .done,
                                    style: .iOS16AppleMusic,
                                    haptic: .success
                                )
                            }
                    case .empty:
                        EmptyView()
                        }
                })
                .overlay {
                    if  newEntryVM.fetchPhase == .fetchingNextPage(lastLogbooks) || netWorkActivitIndicatorManager.isNetworkActivityIndicatorVisible {
                        CustomProgressView(message: "Warte auf Antwort...")
                    }
                }
                .task {
                    setDefaults(connected: networkReachablility.connected)
                }
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
            await newEntryVM.load(forceFetching: true, connected: connected)
            newEntryVM.newLogbook.mileAge.current = getLogbookForVehicle(lastLogbooks: lastLogbooks, vehicle: .Ferrari)?.mileAge.new ?? 0
            newEntryVM.newLogbook.vehicle = .Ferrari
            newEntryVM.newLogbook.driver = currentDriver
        }
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
