//
//  AddEntryView.swift
//  Logbook
//
//  Created by Thomas on 28.07.22.
//

import SwiftUI
import SwiftUIIntrospect

struct AddEntryView: View {
    
    @StateObject var newEntryVM = NewEntryViewModel()
    @Environment(\.dismiss) var dismiss
    
    @State var showAddInfoSelection = false
    @State var savedLogbook: LogbookEntry?
    @Binding var show: Bool
    
    @AppStorage("currentDriver") var currentDriver: DriverEnum = .Andrea
    
    @EnvironmentObject var networkReachablility: NetworkReachability
//    @EnvironmentObject var model: Model
    @EnvironmentObject var logbooksVM: LogbooksViewModel
    @EnvironmentObject var nAIM: NetworkActivityIndicatorManager
        
    let mediumDateAndTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "de_DE")
        return formatter
    }()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    HStack (spacing: 0) {
                        if newEntryVM.fetchPhase == .fetchingNextPage(lastLogbooks) || nAIM.isVisible {
                            ProgressView()
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
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .navigationTitle("Neuer Eintrag")
                .padding(.horizontal, 10)
                .sheet(isPresented: $showAddInfoSelection) {
                    AddInfoSelectComponent(showAddInfoSelection: $showAddInfoSelection, newLogbook: $newEntryVM.newLogbook)
                        .presentationDetents([.fraction(CGFloat(0.45))])
                        .presentationCornerRadius(30)
                        .presentationBackground(.thinMaterial)
                        .onAppear {
                            savedLogbook = newEntryVM.newLogbook
                        }
                }
                .overlay {
                    if  newEntryVM.fetchPhase == .fetchingNextPage(lastLogbooks) || nAIM.isVisible {
                        ZStack{}
                            .onAppear {
                                showSpinningAlert(title: "Laden...")
                            }
                            .onDisappear {
                                dismissAllAlerts()
                            }
                    }
                }
                .task(setDefaults)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        AlternativeCloseButton(action: {
                            withAnimation {
                                show.toggle()
                            }
                        })
                        .padding(.top, 18)
                        .padding(.trailing, 5)
                        .opacity(showAddInfoSelection ? 0.2 : 1)
                        .onReceive(newEntryVM.$sendPhase) { newValue in
                            dismissAllAlerts()
                            switch newValue {
                            case .sending:
                                showSpinningAlert()
                            case .success(let logbook):
                                showSuccessfulAlert()
                                show.toggle()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    withAnimation {
                                        logbooksVM.loadedLogbooks.insert(logbook, at: 0)
                                        logbooksVM.phase = .success(logbooksVM.loadedLogbooks)
                                    }
                                    // model.lastAddedEntry = Date()  // Alternative: Trigger listener on listview to force update the logbooks
                                }
                            case .failure(_):
                                showFailureAlert()
                            default:
                                break
                            }
                        }
                    }
                }
            }
        }
        .offset(y: showAddInfoSelection ? -25 : 0)
    }
    
    @Sendable
    private func setDefaults() async {
        await newEntryVM.load(forceFetching: true)
        newEntryVM.newLogbook.mileAge.current = getLogbookForVehicle(lastLogbooks: lastLogbooks, vehicle: .Ferrari)?.mileAge.new ?? 0
        newEntryVM.newLogbook.vehicle = .Ferrari
        newEntryVM.newLogbook.driver = currentDriver
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
        AddEntryView(show: .constant(true))
            .preferredColorScheme(.light)
//            .environmentObject(NetworkReachability())
    }
}
