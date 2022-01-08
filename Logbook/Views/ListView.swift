//
//  ListView.swift
//  Logbook
//
//  Created by Thomas on 05.01.22.
//

import SwiftUI
import PopupView

struct ListView: View {
    @StateObject var viewModel = LogbookListViewModel()
    @State private var editMode = EditMode.inactive
    @StateObject var popupModel = PopupModel()
    private var fixedHeight = false
    private let topPadding = 80.0
    @State private var searchText = ""
    
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
                }.onDelete(perform: deleteItems)
            }
            .overlay(
                Group {
                    if viewModel.isLoading {
                        ProgressView()
                    }
                }
            )
            .alert(isPresented: $viewModel.showAlert, content: {
                Alert(title: Text("Application Error"), message: Text(viewModel.errorMessage ?? ""))
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
        .popup(isPresented: $popupModel.showPopup, type: .toast, position: .bottom, closeOnTap: false, closeOnTapOutside: false, dismissCallback: {
            viewModel.fetchLogbooks()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                popupModel.popPopup = true
            }
        }) {
            if(!popupModel.popPopup) {
            ZStack {
                //                    bgColor.cornerRadius(40, corners: [.topLeft, .topRight])
                VStack {
                    Color.orange
                        .frame(width: 72, height: 6)
                        .clipShape(Capsule())
                        .padding(.top, 15)
                        .padding(.bottom, 10)
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
    }
    
    
    func deleteItems(at offsets: IndexSet) {
        viewModel.logbooks.remove(atOffsets: offsets)
    }
    
    private var AddButton: some View {
        switch editMode {
        case .inactive:
            return AnyView(Button(action: onAdd) { Image(systemName: "plus.circle") })
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
