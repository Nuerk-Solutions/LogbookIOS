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
            if detailViewModel.logbook != nil && !detailViewModel.isLoading {
                AddLogbookView(currentLogbook: detailViewModel.logbook!, isReadOnly: true, showSheet: $none)
            } else {
                CustomProgressView(message: "Laden...")
            }
        }
        .alert(isPresented: $detailViewModel.showAlert, content: {
            Alert(title: Text("Fehler!"), message: Text(detailViewModel.errorMessage ?? ""))
        })
        .task {
            detailViewModel.logbookId = logbookId
            await detailViewModel.fetchLogbookById()
        }
    }
}

struct DetailLogbookView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
    }
}
