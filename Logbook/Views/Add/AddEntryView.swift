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
    
    @State var showModal = false
    @State var isLoading = false
    @Binding var show: Bool
    @Binding var showTab: Bool
    @Binding var lastAddedEntry: Date
    @State private var canSubmit = false
    @State private var showAddInfoSelection = false
    
    @AppStorage("currentDriver") var currentDriver: DriverEnum = .Andrea
    @AppStorage("currentVehicle") var currentVehicle: VehicleEnum = .Ferrari
    
    @EnvironmentObject var networkReachablility: NetworkReachability
    
    @Namespace var namespace
    
    var distanceSubtraction: Double {
        Double(newEntryVM.newLogbook.mileAge.new - newEntryVM.newLogbook.mileAge.current)
    }
    
    var distance: Double {
        newEntryVM.newLogbook.vehicle == .MX5 ? distanceSubtraction * 1.60934 : distanceSubtraction
    }
    
    
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
                .opacity(showModal ? 0.4 : 0)
            
            content
                .offset(y: showModal ? -50 : 0)
//                .onChange(of: newEntryVM.newLogbook) { newValue in
//                    withAnimation(.spring()) {
//                        canSubmit = newValue.newMileAge != "" && newValue.mileA != "" && Int(newValue.newMileAge) ?? 0 > Int(newValue.currentMileAge) ?? 0 &&
//                        !newValue.reason.isEmpty
//                    }
//                }
            
//            if showModal {
//                AddAdditionalInfoView(newLogbook: $newEntryVM.newLogbook, show: $showModal)
//                    .opacity(showModal ? 1 : 0)
//                    .offset(y: showModal ? 0 : 300)
//                    .overlay(
//                        HStack(alignment: .center) {
//                            Spacer()
//                            Button {
//                                withAnimation(.spring()) {
//                                    showModal.toggle()
//                                }
//                            } label: {
//                                Image(systemName: "xmark")
//                                    .frame(width: 36, height: 36)
//                                    .foregroundColor(.black)
//                                    .background(.white)
//                                    .mask(Circle())
//                                    .shadow(color: Color("Shadow").opacity(0.3), radius: 5, x: 0, y: 3)
//                            }
//                            Spacer()
//                            if newEntryVM.newLogbook.additionalInformationTyp != .Keine {
//                                Button {
//                                    withAnimation(.spring()) {
//                                        showModal.toggle()
//                                        newEntryVM.newLogbook.additionalInformationTyp = .Keine
//                                        newEntryVM.newLogbook.additionalInformation = ""
//                                        newEntryVM.newLogbook.additionalInformationCost = ""
//                                    }
//                                } label: {
//                                    Image(systemName: "trash")
//                                        .frame(width: 36, height: 36)
//                                        .foregroundColor(.black)
//                                        .background(.white)
//                                        .mask(Circle())
//                                        .shadow(color: Color("Shadow").opacity(0.3), radius: 5, x: 0, y: 3)
//                                }
//                                Spacer()
//                            }
//                        }
//                            .offset(y: showModal ? 0 : 200)
//                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
//                    )
//                    .transition(.opacity.combined(with: .move(edge: .top)))
//                    .zIndex(1)
//            }
            
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
            .offset(y: showModal ? -200 : 55)
            
        }
    }
    
    var content: some View {
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
                AddInfoSelectComponent(showAddInfoSelection: $showAddInfoSelection)
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

public extension TextField
{
    func addDoneButtonOnKeyboard() -> some View
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Fertig", style: .done, target: nil, action: nil)
        doneToolbar.items = [flexSpace, done]
        doneToolbar.sizeToFit()
        return self.introspectTextField
        {
            text_field in
            text_field.inputAccessoryView = doneToolbar
            done.target = text_field
            done.action = #selector( text_field.resignFirstResponder )
        }
    }
}

public extension TextEditor
{
    func addDoneButtonOnKeyboard() -> some View
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Fertig", style: .done, target: nil, action: nil)
        doneToolbar.items = [flexSpace, done]
        doneToolbar.sizeToFit()
        return self.introspectTextEditor
        {
            text_field in
            text_field.inputAccessoryView = doneToolbar
            done.target = text_field
            done.action = #selector( text_field.resignFirstResponder )
        }
    }
}
public extension View {
    
    /// Finds a `UITextField` from a `SwiftUI.TextField`
    func introspectTextEditor(customize: @escaping (UITextView) -> ()) -> some View {
        introspect(selector: TargetViewSelector.siblingContainingOrAncestorOrAncestorChild, customize: customize)
    }
}
