//
//  DetailLogbookView.swift
//  Logbook
//
//  Created by Thomas on 05.01.22.
//

import SwiftUI

struct DetailLogbookView: View {
    var logbookId: String?
    
    @StateObject var viewModel = DetailListViewModel()
    
    var body: some View {
        VStack {
            if !viewModel.isLoading {
            AddLogbookView(currentLogbook: viewModel.logbook!, isReadOnly: true)
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
            .onAppear {
                viewModel.logbookId = logbookId
                viewModel.fetchLogbookById()
            }.disabled(true)
    }
}

struct DetailLogbookView_Previews: PreviewProvider {
    static var previews: some View {
        DetailLogbookView()
    }
}
