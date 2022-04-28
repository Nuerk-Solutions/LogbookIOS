//
//  ListRowView.swift
//  Logbook
//
//  Created by Thomas on 20.03.22.
//

import SwiftUI

struct ListRowView: View {
    
    @Binding var logbook: LogbookModel
    @State var isFirstItem: Bool = false
    
    let readableDateFormat: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.locale = Locale(identifier: "de")
        return dateFormatter
    }()
    
    var body: some View {
        Section {
            NavigationLink {
                DetailView(logbookId: logbook._id, isFirstItem: isFirstItem)
            } label: {
                HStack {
                    Image(logbook.vehicleTyp == .VW ? "car_vw" : logbook.vehicleTyp == .Ferrari ? "logo_small" : "porsche")
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(logbook.vehicleTyp == .Porsche ? 1.2 : 1)
                        .frame(width: 80, height: 75)
                        .offset(y: logbook.vehicleTyp == .Porsche ? -5 : 0)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(logbook.vehicleTyp == .VW ? Color.blue : logbook.vehicleTyp == .Ferrari ? Color.red : Color.gray, lineWidth: 1).opacity(0.5))
                    VStack(alignment: .leading) {
                        Text(logbook.driveReason)
                            .font(.headline)
                        Text(self.readableDateFormat.string(from: logbook.date))
                        Text(logbook.driver.id)
                            .font(.subheadline)
                    }.padding(.leading, 8)
                }.padding(.init(top: 6, leading: 0, bottom: 6, trailing: 0))
            }
        }
    }
}
