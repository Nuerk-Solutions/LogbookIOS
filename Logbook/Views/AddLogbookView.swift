//
//  AddLogbook.swift
//  Logbook
//
//  Created by Thomas on 06.01.22.
//

import SwiftUI

struct AddLogbookView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Text("Mongoose")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                
                Text("Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.")
                    .font(.system(size: 14))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 20)
        }
    }
}

struct AddLogbookViews_Previews: PreviewProvider {
    static var previews: some View {
        AddLogbookView()
    }
}
