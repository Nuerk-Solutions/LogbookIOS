//
//  AddEntryView.swift
//  Logbook
//
//  Created by Thomas on 28.07.22.
//

import SwiftUI
import Introspect
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
    
    @AppStorage("currentDriver") var currentDriver: DriverEnum = .Andrea
    @AppStorage("currentVehicle") var currentVehicle: VehicleEnum = .Ferrari
    
    @EnvironmentObject var networkReachablility: NetworkReachability
    
    @Namespace var namespace
    
    var distanceSubtraction: Double {
            (Double(newEntryVM.newLogbook.newMileAge) ?? 0.0) - (Double(newEntryVM.newLogbook.currentMileAge) ?? 0.0)
    }
    
    var distance: Double {
        newEntryVM.newLogbook.vehicleTyp == .MX5 ? distanceSubtraction * 1.60934 : distanceSubtraction
    }
    
    var cost: Double {
        distance * 0.20
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
                .onChange(of: newEntryVM.newLogbook) { newValue in
                    withAnimation(.spring()) {
                        canSubmit = newValue.newMileAge != "" && newValue.currentMileAge != "" && Int(newValue.newMileAge) ?? 0 > Int(newValue.currentMileAge) ?? 0 &&
                        !newValue.driveReason.isEmpty
                    }
                }
            
            if showModal {
                AddAdditionalInfoView(newLogbook: $newEntryVM.newLogbook, show: $showModal)
                    .opacity(showModal ? 1 : 0)
                    .offset(y: showModal ? 0 : 300)
                    .overlay(
                        HStack(alignment: .center) {
                            Spacer()
                            Button {
                                withAnimation(.spring()) {
                                    showModal.toggle()
                                }
                            } label: {
                                Image(systemName: "xmark")
                                    .frame(width: 36, height: 36)
                                    .foregroundColor(.black)
                                    .background(.white)
                                    .mask(Circle())
                                    .shadow(color: Color("Shadow").opacity(0.3), radius: 5, x: 0, y: 3)
                            }
                            Spacer()
                            if newEntryVM.newLogbook.additionalInformationTyp != .Keine {
                                Button {
                                    withAnimation(.spring()) {
                                        showModal.toggle()
                                        newEntryVM.newLogbook.additionalInformationTyp = .Keine
                                        newEntryVM.newLogbook.additionalInformation = ""
                                        newEntryVM.newLogbook.additionalInformationCost = ""
                                    }
                                } label: {
                                    Image(systemName: "trash")
                                        .frame(width: 36, height: 36)
                                        .foregroundColor(.black)
                                        .background(.white)
                                        .mask(Circle())
                                        .shadow(color: Color("Shadow").opacity(0.3), radius: 5, x: 0, y: 3)
                                }
                                Spacer()
                            }
                        }
                            .offset(y: showModal ? 0 : 200)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    )
                    .transition(.opacity.combined(with: .move(edge: .top)))
                    .zIndex(1)
            }
            
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
            
            
            DatePicker("Datum", selection: $newEntryVM.newLogbook.date, in: (getLogbookForVehicle(vehicle: newEntryVM.newLogbook.vehicleTyp)?.date ?? Date())...Date())
                .customFont(.body)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                Picker("", selection: $newEntryVM.newLogbook.vehicleTyp) {
                    ForEach(VehicleEnum.allCases) { vehicle in
                            if(vehicle == .MX5 || vehicle == .DS) {
                                Text(vehicle.rawValue)
                                    .tag(vehicle)
                            } else {
                                Image("\(getVehicleIcon(vehicleTyp: vehicle))_32")
                                    .tag(vehicle)
                            }
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .customFont(.body)
                .frame(maxWidth: .infinity, alignment: .leading)
                .onChange(of: newEntryVM.newLogbook.vehicleTyp) { newValue in
                    updateVehicleData(vehicle: newValue)
                }
                
                Menu(content: {
                    Picker(selection: $newEntryVM.newLogbook.driver) {
                        ForEach(DriverEnum.allCases) { driver in
                            Text(driver.rawValue)
                                .tag(driver)
                        }
                    } label: {
                        Text("TEST")
                    }
                    .customFont(.body)
                }, label: {
                    Image(systemName: "person.circle")
                        .resizable()
                        .frame(width: 24, height: 24)
                })
            }
            
            VStack(spacing: 8) {
                VStack(alignment: .leading, spacing: 3) {
                    Text(newEntryVM.newLogbook.vehicleTyp == .MX5 ? "Aktueller Meilenstand" : "Aktueller Kilometerstand")
                        .customFont(.subheadline)
                        .foregroundColor(.secondary)
                    TextField("", text: $newEntryVM.newLogbook.currentMileAge)
                        .addDoneButtonOnKeyboard()
                        .customTextField(image: Image(systemName: "car.fill"), suffix: newEntryVM.newLogbook.vehicleTyp == .MX5 ? "mi" : "km")
                        .keyboardType(.decimalPad)
                        .submitLabel(.done)
                        .opacity(0.4)
                        .disabled(true)
                }
                VStack(alignment: .leading, spacing: 3) {
                    Text(newEntryVM.newLogbook.vehicleTyp == .MX5 ? "Neuer Meilenstand" : "Neuer Kilometerstand")
                        .customFont(.subheadline)
                        .foregroundColor(.secondary)
                    TextField("", text: $newEntryVM.newLogbook.newMileAge)
                        .addDoneButtonOnKeyboard()
                        .customTextField(image: Image(systemName: "car.2.fill"), suffix: newEntryVM.newLogbook.vehicleTyp == .MX5 ? "mi" : "km")
                        .keyboardType(.decimalPad)
                        .submitLabel(.done)
                }
                VStack(alignment: .leading, spacing: 3) {
                    Text("Reiseziel")
                        .customFont(.subheadline)
                        .foregroundColor(.secondary)
                    TextField("", text: $newEntryVM.newLogbook.driveReason)
                        .addDoneButtonOnKeyboard()
                        .customTextField(image: Image(systemName: "scope"))
                        .introspectTextField(customize: {
                            $0.clearButtonMode = .whileEditing
                        })
                }
            }
            
            
            HStack {
                Image(systemName: newEntryVM.newLogbook.forFreeBool ? "checkmark.square.fill" : "x.square.fill")
                    .resizable()
                    .frame(width: 26, height: 26)
                    .cornerRadius(10)
                    .padding(8)
                    .background(.ultraThinMaterial)
                    .backgroundStyle(cornerRadius: 18, opacity: 0.4)
                    .foregroundColor(newEntryVM.newLogbook.forFreeBool ? .green : .red)
                Text(newEntryVM.newLogbook.forFreeBool ? "Die Fahrt wird übernommen" : "Die Fahrt wird nicht übernommen.")
                    .font(.footnote.weight(.medium))
                    .padding(6)
                //                    .foregroundStyle(.secondary)
                    .background(.secondary)
                    .mask(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(lineWidth: 1).fill(.black.opacity(0.1)))
            }
            .onTapGesture {
                withAnimation {
                    newEntryVM.newLogbook.forFree?.toggle()
                }
            }
            .accessibilityElement(children: .combine)
            
            HStack {
                Button {
                    DispatchQueue.main.async {
                        withAnimation(.spring()) {
                            showModal.toggle()
                            newEntryVM.newLogbook.additionalInformationTyp = .Getankt
                        }
                    }
                } label: {
                    Image(systemName: newEntryVM.newLogbook.additionalInformationTyp == .Keine ? "link.badge.plus" : "link")
                        .resizable()
                        .frame(width: 26, height: 26)
                        .symbolRenderingMode(newEntryVM.newLogbook.additionalInformationTyp == .Keine ? .multicolor : .hierarchical)
                        .foregroundColor(.primary)
                        .cornerRadius(10)
                        .padding(8)
                        .background(.ultraThinMaterial)
                        .backgroundStyle(cornerRadius: 18, opacity: 0.4)
                }
                
                if newEntryVM.newLogbook.additionalInformationTyp == .Keine {
                    Text("Zusätzliche Information hinzufügen")
                        .font(.footnote.weight(.medium))
                        .padding(6)
                        .background(.secondary)
                        .mask(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(lineWidth: 1).fill(.black.opacity(0.1)))
                        .fixedSize(horizontal: false, vertical: true)
                } else {
                    HStack {
                        Text("Zusätzliche Information öffnen")
                            .font(.footnote.weight(.medium))
                        //
                        //                            Image(systemName: "line.diagonal.arrow")
                        //                                .resizable()
                        //                                .frame(width: 20, height: 20)
                        //                                .foregroundColor(.primary)
                    }
                    .lineLimit(2)
                    .padding(6)
                    .background(.secondary)
                    .mask(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(lineWidth: 1).fill(.black.opacity(0.1)))
                }
                
            }
            .onTapGesture {
                withAnimation(.spring()) {
                    showModal.toggle()
                }
            }
            if(canSubmit) {
                Text("Zusammenfassung: \(String(format: "%.0fkm", distance)) / \(cost.formatted(.currency(code: "EUR").locale(Locale(identifier: "de-DE"))))")
                    .matchedGeometryEffect(id: "summaryText", in: namespace)
                    .transition(.identity)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                Text("Bitte überprüfe deine Angaben!")
                    .matchedGeometryEffect(id: "summaryText", in: namespace)
                    .transition(.identity)
            }
            VStack {
                Spacer()
                
                Button {
                    if !canSubmit {
                        return
                    }
                    playSaveAnimation()
                } label: {
                    HStack {
                        Image(systemName: "arrow.right")
                        Text("Fahrt hinzufügen")
                            .customFont(.headline)
                    }
                    .largeButton(disabled: !canSubmit)
                }
                .opacity(!canSubmit ? 0 : 1)
                .transition(.identity)
                .disabled(!canSubmit || isLoading)
                //                Spacer()
            }
        }
        .padding(.horizontal, 40)
        .padding(.top, 80)
        .padding(.bottom, 40)
        .background(.ultraThinMaterial)
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
    
    private func setDefaults(connected: Bool) {
        Task {
            await newEntryVM.load(connected: connected)
            updateVehicleData(vehicle: currentVehicle)
            newEntryVM.newLogbook.vehicleTyp = currentVehicle
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
    
    private func getLogbookForVehicle(vehicle: VehicleEnum) -> LogbookEntry? {
        lastLogbooks.first { entry in
            entry.vehicleTyp == vehicle
        }
    }
    
    private func updateVehicleData(vehicle newValue: VehicleEnum) {
        currentVehicle = newValue
        newEntryVM.newLogbook.currentMileAge = getLogbookForVehicle(vehicle: newValue)?.newMileAge ?? "Laden..."
        // MARK: - Set above the cache value
    }
    
    
    func playSaveAnimation() {
        withAnimation(.spring()) {
            isLoading = true
        }
        
        if canSubmit {
            Task {
                await newEntryVM.send(connected: networkReachablility.connected)
                lastAddedEntry = Date()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                withAnimation(.spring()) {
                    isLoading = false
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.1) {
                withAnimation(.spring()) {
                    show = false
                    showTab = true
                }
            }
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
