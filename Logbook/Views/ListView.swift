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
    @State private var searchText = ""
    
    @State private var showSheet: Bool = false
    
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
                                Text(logbook.vehicleTyp.id)
                                Text("-")
                                Text(String(logbook.distance) + " km")
                            }
                        }.padding(.bottom, 5)
                    }
                }
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
            .navigationBarItems(trailing: AddButton)
            .listStyle(.plain)
            .refreshable {
                viewModel.fetchLogbooks()
            }
            .searchable(text: $searchText)
            .onAppear {
                viewModel.fetchLogbooks()
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
                }
                    .disabled((viewModel.errorMessage) != nil)
                    .halfSheet(showSheet: $showSheet) {
                        ZStack {
                            Color.white
                            
                            AddLogbookView(currentLogbook: Logbook(), showSheet: $showSheet)
                        }.ignoresSafeArea()
                    } onEnd: {
                        print("Dismiss")
                        viewModel.fetchLogbooks()
                    }
            )
        default:
            return AnyView(EmptyView())
        }
    }
    
    func onAdd() {
        showSheet.toggle()
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
    
    func halfSheet<SheetView: View>(showSheet: Binding<Bool>, @ViewBuilder sheetView: @escaping () -> SheetView, onEnd: @escaping () -> ()) -> some View {
        return self
            .background(
                HalfSheetHelper(sheetView: sheetView(), showSheet: showSheet, onEnd: onEnd)            )
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
            let sheetController = CustomHostingController(rootView: sheetView, onEnd1: onEnd)
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

