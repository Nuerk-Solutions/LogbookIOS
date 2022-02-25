//
//  MultipleSelectionRow.swift
//  Logbook
//
//  Created by Thomas on 24.02.22.
//

import SwiftUI

struct ExportSelectionRowView: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: self.action) {
            HStack {
                Text(self.title)
                if self.isSelected {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}

struct ExportSelectionRowView_Previews: PreviewProvider {
    static var previews: some View {
        ExportSelectionRowView(title: "Test", isSelected: false) {
        }
    }
}
