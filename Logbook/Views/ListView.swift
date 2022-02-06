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
import KeyboardAvoider

struct ListView: View {
    @StateObject var listViewModel = ListViewModel()
    @StateObject var alertManager = AlertManager()
    @StateObject private var locationService: LocationService
    
    @State private var editMode = EditMode.inactive
    @State private var searchText = ""
    @State private var shouldLoad = true
    
    @State private var showSheet: Bool = false
    
    let readableDateFormat: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.locale = Locale(identifier: "de")
        return dateFormatter
    }()
    
    init() {
        UITableView.appearance().sectionFooterHeight = 0
        _locationService = StateObject(wrappedValue: LocationService())
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(searchResults) { logbook in
                    Section {
                        NavigationLink {
                            DetailView(logbookId: logbook._id)
                        } label: {
                            HStack {
                                Image(logbook.vehicleTyp == .VW ? "car_vw" : "logo_small")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 75)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(logbook.vehicleTyp == .VW ? Color.blue : Color.black, lineWidth: 1).opacity(0.5))
                                VStack(alignment: .leading) {
                                    Text(logbook.driveReason)
                                        .font(.headline)
                                    Text(self.readableDateFormat.string(from: logbook.date))
                                    Text(logbook.driver.id)
                                        .font(.subheadline)
                                }.padding(.leading, 8)
                            }.padding(.init(top: 6, leading: 0, bottom: 6, trailing: 0))
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .refreshable {
                await listViewModel.fetchLogbooks()
            }
            .navigationTitle("Fahrtenbuch")
            .navigationBarItems(trailing: AddButton)
            .listStyle(.plain)
            .overlay(
                Group {
                    if listViewModel.isLoading {
                        ProgressView()
                    }
                    
                    if(listViewModel.errorMessage != nil) {
                        VStack {
                            Text("Bitte verbinde dich mit dem Internet um einen neuen Eintrag hinzuzufügen!").foregroundColor(.red)
                                .fontWeight(.bold)
                                .font(.title)
                        }.onAppear {
                            withAnimation {
                                listViewModel.logbooks.removeAll()
                            }
                        }
                    }
                }
            )
            
            .alert(isPresented: $listViewModel.showAlert, content: {
                Alert(title: Text("Fehler!"), message: Text(listViewModel.errorMessage ?? ""))
            })
            .searchable(text: $searchText)
            .onAppear {
                if shouldLoad {
                    locationService.requestLocationPermission(always: true)
                        Task {
                            await listViewModel.fetchLogbooks()
                        }
                        shouldLoad = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
                            showSheet = true
                        }
                }
            }
            
        }
        .uses(alertManager)
    }
    
    private var AddButton: some View {
        switch editMode {
        case .inactive:
            return AnyView(
                Button(action: onAdd) {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
                    .disabled((listViewModel.errorMessage) != nil)
                    .sheet(isPresented: $showSheet, content: {
                        if(listViewModel.isLoading) {
                            ProgressView()
                        } else {
                            AddLogbookView(showSheet: $showSheet)
                                .avoidKeyboard()
                                .environmentObject(listViewModel)
                                .ignoresSafeArea(.all, edges: .all)
                        }
                    })
                //                    .halfSheet(showSheet: $showSheet) {
                //                            AddLogbookView(currentLogbook: Logbook(), showSheet: $showSheet)
                //                            .edgesIgnoringSafeArea(.all)
                //                    } onEnd: {
                //                    }
                //                    .onChange(of: showSheet, perform: { newValue in
                //                        if(!newValue) {
                //                            withAnimation {
                //                                viewModel.fetchLogbooks()
                //                            }
                //                        }
                //                    })
            )
        default:
            return AnyView(EmptyView())
        }
    }
    
    func onAdd() {
        showSheet.toggle()
    }
    
    var searchResults: [LogbookModel] {
        if searchText.isEmpty {
            return listViewModel.logbooks
        } else {
            return listViewModel.logbooks.filter{$0.driveReason.contains(searchText) || readableDateFormat.string(from: $0.date).contains(searchText) || $0.driver.id.contains(searchText)}
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
    
    func halfSheet<SheetView: View>(showSheet: Binding<Bool>, @ViewBuilder sheetView: @escaping () -> SheetView, onEnd: @escaping () -> ()) -> some View {
        return self
            .background(
                HalfSheetHelper(sheetView: sheetView(), showSheet: showSheet, onEnd: onEnd)
            )
    }
}

struct HalfSheetHelper<SheetView: View>: UIViewControllerRepresentable {
    
    var sheetView: SheetView
    @Binding var showSheet: Bool
    var onEnd: ()->()
    
    let controller = UIViewController()
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        controller.view.backgroundColor = .clear
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
        if showSheet {
            let sheetController = CustomHostingController(rootView: sheetView)
            sheetController.presentationController?.delegate = context.coordinator
            uiViewController.present(sheetController, animated: true)
        } else {
            uiViewController.dismiss(animated: true)
        }
    }
    
    class Coordinator: NSObject, UISheetPresentationControllerDelegate {
        var parent: HalfSheetHelper
        
        init(parent: HalfSheetHelper) {
            self.parent = parent
        }
        
        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            parent.showSheet = false
            parent.onEnd()
        }
    }
    
    
    class CustomHostingController<Content: View>: UIHostingController<Content>{
        
        override func viewDidLoad() {
            
            view.backgroundColor = .clear
            
            if let presentationController = presentationController as? UISheetPresentationController {
                presentationController.detents = [
                    .large()
                    // add .medium to show halft Sheet
                ]
                presentationController.prefersGrabberVisible = true
            }
        }
    }
}

