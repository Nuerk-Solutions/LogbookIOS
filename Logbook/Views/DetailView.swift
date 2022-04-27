//
//  DetailLogbookView.swift
//  Logbook
//
//  Created by Thomas on 05.01.22.
//

import SwiftUI

struct DetailView: View {
    var logbookId: String?
    @State private var none: Bool = false
    
    @StateObject var detailViewModel = DetailViewModel()
    
    var body: some View {
        VStack {
            if detailViewModel.detailedLogbook != nil && !detailViewModel.isLoading {
                AddLogbookView(currentLogbook: detailViewModel.detailedLogbook!, isReadOnly: true, showSheet: $none)
                    .navigationBarTitleDisplayMode(.inline)
            } else {
                CustomProgressView(message: "Laden...")
            }
        }
        .alert(isPresented: $detailViewModel.showAlert, content: {
            Alert(title: Text("Fehler!"), message: Text(detailViewModel.errorMessage ?? ""))
        })
        .task {
            await detailViewModel.fetchLogbookById(logbookId: logbookId)
        }
    }
}

struct DetailLogbookView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
    }
}
