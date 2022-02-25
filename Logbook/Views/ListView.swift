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
    @State private var showHelp: Bool = false
    @State private var showShare: Bool = false
    @State private var showExportSelection: Bool = false
    
    let readableDateFormat: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.locale = Locale(identifier: "de")
        return dateFormatter
    }()
    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    var fileURL = ""
    
    
    @Environment(\.presentationMode) var presentationMode
    
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
            .toolbar(content: {
                ToolbarItem(id: "First", placement: .navigationBarTrailing, showsByDefault: true) {
                    AddButton
                }
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    RefuelButton
                    
                        ExportButton
                }
            })
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
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.35) {
                        //                        showSheet = true
                    }
                }
            }
            .onTapGesture(count: 4) {
                consoleManager.isVisible.toggle()
            }
//            .fileExporter(isPresented: $listViewModel.showMail, document: SpreadSheetFile(data: listViewModel.fileData, filename: (listViewModel.mailData.attachments?.first!.fileName) ?? ""), contentType: .spreadsheet, onCompletion: { result in
//                switch result {
//                case .success(let url):
//                    print("Saved to", url)
//                    do {
//                        guard
//                            let url1 = URL(string: url.absoluteString.replacingOccurrences(of: "file://", with: "shareddocuments://"))
//                        else {
//                            throw APIError.invalidURL
//                        }
//                        UIApplication.shared.open(url1)
//                    } catch {
//                        print(error)
//                    }
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            })
        }
        .uses(alertManager)
    }
    
    private var RefuelButton: some View {
        return AnyView(
            Button(action: {
                showHelp.toggle()
            }, label: {
                Image(systemName: "fuelpump.circle")
                    .resizable()
                    .frame(width: 35, height: 35)
            })
            .sheet(isPresented: $showHelp, onDismiss: {
                showHelp = false
                // Todo check if this could be removed
            }, content: {
                RefuelView(locationService: locationService)
                    .ignoresSafeArea(.all, edges: .all)
            })
        )
    }
    
    private var ExportButton: some View {
        
        @State var shareURL: URL? = nil
        
        return AnyView(
                Button(action: {
                    showExportSelection.toggle()
                }, label: {
                    Image(systemName: "square.and.arrow.up")
                        .resizable()
                        .frame(width: 25, height: 30)
                        .padding(.bottom, 3)
                })
                .sheet(isPresented: $showExportSelection, onDismiss: {
                    print("Dismissed")
                }, content: {
                    let drivers = [DriverEnum.Andrea, DriverEnum.Claudia, DriverEnum.Oliver, DriverEnum.Thomas]
                    let vehicles = [VehicleEnum.Ferrari, VehicleEnum.VW]
                    MultipleSelectionList(driver: drivers, selectedDrivers: drivers, vehicle: vehicles, selectedVehicles: vehicles, showShare: $showExportSelection)
                        .overlay(
                            Group (content: {
                                if listViewModel.isLoading {
                                    ProgressView()
                                }
                            })
                        )
                })
//            .background(
//                SharingViewController(isPresenting: $listViewModel.downloaded, content: {
//                let documentsURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//                let fileUrl = documentsURL.appendingPathComponent(listViewModel.mailData.attachments?.first!.fileName ?? "")
//                let av = UIActivityViewController(activityItems: [fileUrl], applicationActivities: nil)
////                av.completionWithItemsHandler = { (activity, success, items, error) in
////                    print("Activity: \(activity) Success: \(success) Items: \(items) Error: \(error)")
////                    if (!success) {
////                        return
////                    }
////                    listViewModel.downloaded.toggle() // required for re-open !!!
////                    showExportSelection.toggle()
////                    print("FINISHED")
////                   }
//                    av.completionWithItemsHandler = { activity, completed, returnedItems, activityError in
//
//
//                        if completed {
//                            print("Completed")
//                        } else {
//                            print("Not completed")
//                        }
//                    }
//                   return av
//               })
//            )
//            .sheet(isPresented: $showShare, content: {
//                if listViewModel.isLoading {
//                    ProgressView()
//                } else {
//                    let documentsURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//                    let fireUrl = documentsURL.appendingPathComponent(listViewModel.mailData.attachments?.first!.fileName ?? "")
//                    ShareSheet(activityItems: [fireUrl])
//                }
//            })
//            .sheet(isPresented: $showMail, onDismiss: {
//                showMail = false
//                // Todo check if this could be removed
//            }, content: {
//                if listViewModel.isLoading {
//                } else {
//                    MailView(data: $listViewModel.mailData) { result in
//                        print(result)
//                    }
//                }
//            })
        )
    }
    
    struct SharingViewController: UIViewControllerRepresentable {
        @Binding var isPresenting: Bool
        var content: () -> UIActivityViewController

        func makeUIViewController(context: Context) -> UIViewController {
            UIViewController()
        }

        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
            if isPresenting {
                UIApplication.shared.windows.first?.rootViewController?.present(uiViewController, animated: true, completion: nil)
            }
            content().completionWithItemsHandler = { activity, completed, returnedItems, activityError in
                

                if completed {
                    print("Completed")
                } else {
                    print("Not completed")
                }
            }
        }
    }
    
    struct ActivityViewController: UIViewControllerRepresentable {
            
        @Binding var shareURL: URL?
        
        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }
        
        func makeUIViewController(context: Context) -> some UIViewController {
            let containerViewController = UIViewController()
            
            return containerViewController

        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            guard let shareURL = shareURL, context.coordinator.presented == false else { return }
            
            context.coordinator.presented = true

            let activityViewController = UIActivityViewController(activityItems: [shareURL], applicationActivities: nil)
            activityViewController.completionWithItemsHandler = { activity, completed, returnedItems, activityError in
                self.shareURL = nil
                context.coordinator.presented = false

                if completed {
                    print("Completed")
                } else {
                    print("Not completed")
                }
            }
            
            // Executing this asynchronously might not be necessary but some of my tests
            // failed because the view wasn't yet in the view hierarchy on the first pass of updateUIViewController
            //
            // There might be a better way to test for that condition in the guard statement and execute this
            // synchronously if we can be be sure updateUIViewController is invoked at least once after the view is added
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                uiViewController.present(activityViewController, animated: true)
            }
        }
        class Coordinator: NSObject {
            let parent: ActivityViewController
            
            var presented: Bool = false
            
            init(_ parent: ActivityViewController) {
                self.parent = parent
            }
        }
    }
    
    
    private var AddButton: some View {
        switch editMode {
        case .inactive:
            return AnyView(
                Button(action: onAdd) {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .frame(width: 35, height: 35)
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

