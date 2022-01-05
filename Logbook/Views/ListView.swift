//
//  ListView.swift
//  Logbook
//
//  Created by Thomas on 05.01.22.
//

import SwiftUI

struct ListView: View {
    @StateObject var viewModel = LogbookListViewModel()
    
    let readableDateFormat: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.locale = Locale(identifier: "de")
        return dateFormatter
    }()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.logbooks) { logbook in
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
            .listStyle(.plain)
            .toolbar {
                EditButton()
            }
            .refreshable {
                viewModel.fetchLogbooks()
            }
            .onAppear {
                viewModel.fetchLogbooks()
            }
        }
    }
    
    
    func deleteItems(at offsets: IndexSet) {
        viewModel.logbooks.remove(atOffsets: offsets)
    }
}


struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ListView()
        }
    }
}
