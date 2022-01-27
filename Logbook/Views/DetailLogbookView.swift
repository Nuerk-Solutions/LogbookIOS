//
//  DetailLogbookView.swift
//  Logbook
//
//  Created by Thomas on 05.01.22.
//

import SwiftUI

struct DetailLogbookView: View {
    var logbookId: String?
    @State private var none: Bool = false
    
    @StateObject var viewModel = DetailListViewModel()
    
    var body: some View {
        VStack {
            if !viewModel.isLoading {
                AddLogbookView(currentLogbook: viewModel.logbook, isReadOnly: true, showSheet: $none)
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
                withAnimation {
                    viewModel.logbookId = logbookId
                    viewModel.fetchLogbookById()
                }
            }
    }
}

struct DetailLogbookView_Previews: PreviewProvider {
    static var previews: some View {
        DetailLogbookView()
    }
}
