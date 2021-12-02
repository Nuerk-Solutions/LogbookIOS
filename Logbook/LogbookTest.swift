//
//  LogbookTest.swift
//  Logbook
//
//  Created by Thomas on 02.12.21.
//

import SwiftUI

struct LogbookTest: View {
    @State var logbookEntries: [Logbook] = []
    var body: some View {
        List(logbookEntries) { item in
            Text(item.driveReason)
        }.onAppear {
            Api().getLogbookEntries{(logbooks) in
                self.logbookEntries = logbooks
            }
    }
    }
}

struct LogbookTest_Previews: PreviewProvider {
    static var previews: some View {
        LogbookTest()
    }
}
