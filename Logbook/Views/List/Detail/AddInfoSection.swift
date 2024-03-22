//
//  AddInfoSection.swift
//  Logbook
//
//  Created by Thomas Nürk on 01.01.24.
//

import SwiftUI

struct AddInfoSection: View {
    
    var entry: LogbookEntry
    
    var body: some View {
        Group {
            if entry.service != nil {
                AddInfoDetailStackCompoent(entry: entry)
            }
            if entry.refuel != nil {
                AddInfoDetailStackCompoent(entry: entry)
            }
        }
    }
}

#Preview {
    AddInfoSection(entry: LogbookEntry.previewData.data[0])
}
