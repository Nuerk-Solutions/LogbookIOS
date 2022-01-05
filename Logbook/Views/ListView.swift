//
//  ListView.swift
//  Logbook
//
//  Created by Thomas on 05.01.22.
//

import SwiftUI

struct ListView: View {
    @StateObject var viewModel = LogbookListViewModel()
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.logbooks) { logbook in
                    NavigationLink {
                        DetailLogbookView(logbookId: logbook.id)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(logbook.driveReason)
                                .font(.headline)
                            Text(logbook.vehicle.typ.id)
                            
                        }
                    }
                }
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
            .navigationTitle("Einträge")
            .listStyle(.plain)
            .refreshable {
                viewModel.fetchLogbooks()
            }
            .onAppear {
                viewModel.fetchLogbooks()
            }
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
