//
//  SettingsRowView.swift
//  Logbook
//
//  Created by Thomas on 15.03.22.
//

import SwiftUI

struct SettingsRowView: View {
    
    var name: String
    var content: String? = nil
    var linkLabel: String? = nil
    var linkDestination: String? = nil
    
    var body: some View {
        HStack {
            Text(name).foregroundColor(.gray)
            Spacer()
            if content != nil {
                Text(content!)
            } else if linkLabel != nil && linkDestination != nil {
                Link(linkLabel!, destination: URL(string: linkDestination!)!)
                Image(systemName: "arrow.up.right.square").foregroundColor(.pink)
            } else {
                EmptyView()
            }
        }
    }
}

struct SettingsRowView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsRowView(name: "Thomas")
            .previewLayout(.fixed(width: 375, height: 60))
            .padding()
    }
}
