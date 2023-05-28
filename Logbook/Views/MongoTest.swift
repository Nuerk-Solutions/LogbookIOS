//
//  MongoTest.swift
//  Logbook
//
//  Created by Thomas on 22.05.23.
//

import SwiftUI
import RealmSwift

struct MongoTest: View {
    @ObservedResults(logbook.self, sortDescriptor: SortDescriptor.init(keyPath: "date", ascending: false)) var items
    @EnvironmentObject var errorHandler: ErrorHandler
    
    
    var body: some View {
        VStack {
            List {
                ForEach(items) { item in
                    Text(item.driveReason)
                }
                .onDelete(perform: { offset in
                    if let index = offset.first {
                        let item = items[index]
                        $items.remove(atOffsets: offset)
                        
                        if let item = item.thaw(),
                            let realm = item.realm {
                            try? realm.write({
                                realm.delete(item)
                            })
                        }
                    }
                   
                    
                })
            }
            .listStyle(InsetListStyle())
            Spacer()
            Text("Log in or create a different account on another device or simulator to see your list sync in real time")
                .frame(maxWidth: 300, alignment: .center)
        }
        .navigationBarTitle("Items", displayMode: .inline)
    }
}

struct MongoTest_Previews: PreviewProvider {
    static var previews: some View {
        MongoTest()
    }
}
