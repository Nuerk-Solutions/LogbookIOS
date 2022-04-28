//
//  DetailLogbookView.swift
//  Logbook
//
//  Created by Thomas on 05.01.22.
//

import SwiftUI
import AlertKit

struct DetailView: View {
    var logbookId: String?
    @State var isFirstItem: Bool = false
    @State private var none: Bool = false
    
    @StateObject var detailViewModel = DetailViewModel()
    @StateObject var alertManager = AlertManager()
    
    var body: some View {
        VStack {
            if detailViewModel.detailedLogbook != nil && !detailViewModel.isLoading {
                AddLogbookView(currentLogbook: detailViewModel.detailedLogbook!, isReadOnly: true, isFirstItem: isFirstItem, showSheet: $none, alertManager: alertManager)
                    .navigationBarTitleDisplayMode(.inline)
            } else {
                CustomProgressView(message: "Laden...")
            }
        }
        .alert(isPresented: $detailViewModel.showAlert, content: {
            Alert(title: Text("Fehler!"), message: Text(detailViewModel.errorMessage ?? ""))
        })
        .onAppear {
            detailViewModel.fetchLogbookById(logbookId: logbookId)
        }
        .uses(alertManager)
    }
}

struct DetailLogbookView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
    }
}
