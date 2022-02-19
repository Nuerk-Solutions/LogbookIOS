//
//  HelpView.swift
//  Logbook
//
//  Created by Thomas on 19.02.22.
//

import SwiftUI

struct HelpView: View {
    var body: some View {
        Form {
            Section(header: Text("Ferrari")) {
                VStack (alignment: .leading) {
                    Spacer()
                    Text("Was wird getankt?").font(.headline)
                    Spacer()
                    Text("In den Ferrari wird nur E5, Super oder Super+ getankt.")
                    Spacer()
                    Spacer()
                    Text("Kein E10 oder Super E10 oder Ad Blue !").underline(true, color: .red).foregroundColor(.red)
                        .bold()
                    
                    Spacer()
                    Spacer()
                }
            }.headerProminence(.increased)
            
            Section(header: Text("Ferrari")) {
                VStack (alignment: .leading) {
                    Spacer()
                    Text("Was wird getankt?").font(.headline)
                    Spacer()
                    Text("In den VW wird nur Diesel getankt.")
                    Spacer()
                }
            }.headerProminence(.increased)
        }
    }
}


struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}
