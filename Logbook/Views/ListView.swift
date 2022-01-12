//
//  ListView.swift
//  Logbook
//
//  Created by Thomas on 05.01.22.
//

import SwiftUI
import PopupView
import SPAlert
import AlertKit

struct ListView: View {
    @StateObject var viewModel = LogbookListViewModel()
    @StateObject var alertManager = AlertManager()
    @State private var editMode = EditMode.inactive
    @StateObject var popupModel = PopupModel()
    private var fixedHeight = true
    private let topPadding = 110.0
    @State private var searchText = ""
    
    @State private var showConfimationDialog = false
    @State private var showSheet = false
    
    let readableDateFormat: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.locale = Locale(identifier: "de")
        return dateFormatter
    }()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(searchResults) { logbook in
                    NavigationLink {
                        DetailLogbookView(logbookId: logbook._id)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(logbook.driveReason + " (\(self.readableDateFormat.string(from: logbook.date)))")
                                .font(.headline)
                            Text(logbook.driver.id)
                            HStack (spacing: 5) {
                                Text(logbook.vehicle.typ.id)
                                Text("-")
                                Text(String(logbook.vehicle.distance!) + " km")
                            }
                        }.padding(.bottom, 5)
                    }
//                    .swipeActions(edge: .trailing) {
//                        Button(
//                            role: .destructive,
//                            action: {
//                                showConfimationDialog = true
//                            }
//                        ){
//                            Image (systemName: "trash")
//                        }
//                    }
                
                }
                .onDelete(perform: { IndexSet in
                            showConfimationDialog = true
                        //deleteItems(at: IndexSet)
                })
//                .confirmationDialog(
//                    "Are you sure?",
//                    isPresented: $showConfimationDialog,
//                    titleVisibility: .visible
//                ) {
//                    Button("Yes") {
//                        withAnimation {
//                            //viewModel.delete(message)
//                            print("DELTED")
//                        }
//                    }.keyboardShortcut(.defaultAction)
//
//                    Button("No", role: .cancel) {}
//                } message: {
//                    Text("This action cannot be undone")
//                }
            }
            .overlay(
                Group {
                    if viewModel.isLoading {
                        ProgressView()
                    }
                    
                    if(viewModel.errorMessage != nil) {
                        VStack {
                            Text("Bitte verbinde dich mit dem Internet um einen neuen Eintrag hinzuzufügen!").foregroundColor(.red)
                                .fontWeight(.bold)
                                .font(.title)
                        }.onAppear {
                            viewModel.logbooks.removeAll()
                        }
                    }
                }
            )
            .alert(isPresented: $viewModel.showAlert, content: {
                Alert(title: Text("Fehler!"), message: Text(viewModel.errorMessage ?? ""))
            })
            .navigationTitle("Fahrtenbuch")
            .navigationBarItems(leading: EditButton(), trailing: AddButton)
            .environment(\.editMode, $editMode)
            .listStyle(.plain)
            .refreshable {
                viewModel.fetchLogbooks()
            }
            .searchable(text: $searchText)
            .onAppear {
                viewModel.fetchLogbooks()
            }
        }
        .halfSheet(showSheet: $showSheet) {
            
        }
        
        .popup(isPresented: $popupModel.showPopup, type: .toast, position: .bottom, closeOnTap: false, closeOnTapOutside: false, dismissCallback: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                popupModel.popPopup = true
                viewModel.fetchLogbooks()
            }
        }) {
            if(!popupModel.popPopup) {
                ZStack {
                    VStack {
                        Color.accentColor
                            .frame(width: 72, height: 6)
                            .clipShape(Capsule())
                            .padding(.top, 30)
                            .padding(.bottom, 25)
                        AddLogbookView(currentLogbook: Logbook(), isReadOnly: false)
                            .padding(.bottom, 30)
                            .frame(minHeight: UIScreen.main.bounds.height - topPadding)
                            .applyIf(fixedHeight) {
                                $0.frame(height: UIScreen.main.bounds.height - topPadding)
                            }
                            .applyIf(!fixedHeight) {
                                $0.frame(maxHeight: UIScreen.main.bounds.height - topPadding)
                            }
                            .environmentObject(self.popupModel)
                        
                    }.background(.regularMaterial).cornerRadius(40, corners: [.topLeft, .topRight])
                    
                }
                .fixedSize(horizontal: false, vertical: true)
            }
        }
        .uses(alertManager)
    }
    
    
    func deleteItems(at offsets: IndexSet) {
        alertManager.show(primarySecondary: .info(title: "Eintrag löschen?", message: "Das löschen des Eintrags kann nicht rückgängig gemacht werden!", primaryButton: Alert.Button.destructive(Text("Ja")) {
            
            let index = offsets[offsets.startIndex]
            //viewModel.deleteLogbook(queryParamter: viewModel.logbooks[index]._id!)
            viewModel.logbooks.remove(atOffsets: offsets)
            
        }, secondaryButton: Alert.Button.cancel(Text("Abbrechen"))))
    }
    
    private var AddButton: some View {
        switch editMode {
        case .inactive:
            return AnyView(Button(action: onAdd) { Image(systemName: "plus.circle") }.disabled((viewModel.errorMessage) != nil))
        default:
            return AnyView(EmptyView())
        }
    }
    
    func onAdd() {
        popupModel.showPopup.toggle()
        popupModel.popPopup = false
    }
    
    var searchResults: [Logbook] {
        if searchText.isEmpty {
            return viewModel.logbooks
        } else {
            return viewModel.logbooks.filter{$0.driveReason.contains(searchText) || readableDateFormat.string(from: $0.date).contains(searchText) || $0.driver.id.contains(searchText)}
        }
    }
}


struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ListView()
        }
    }
}


// Temp extension
extension View {
    
    func halfSheet<SheetView: View>(showSheet: Binding<Bool>, @ViewBuilder sheetView: @escaping () -> SheetView) -> some View {
        return self
    }
}
