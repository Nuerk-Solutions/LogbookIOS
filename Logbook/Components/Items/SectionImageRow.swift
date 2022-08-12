//
//  SectionRow2.swift
//  Logbook
//
//  Created by Thomas on 09.06.22.
//

import SwiftUI

struct SectionImageRow<Content: View>: View {
    
    var imageName: String?
    @State var circleValue: Double?
    @State var progressValue: Double?
    @ViewBuilder var content: Content
    
    @EnvironmentObject private var model: Model
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(imageName ?? "Logo Ferrari")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 24, height: 24)
                .frame(width: 45, height: 45)
                .mask(Circle())
                .padding(6)
                .background(Color(UIColor.systemBackground).opacity(0.3))
                .mask(Circle())
                .overlay(CircularView(value: circleValue ?? 1, appear: circleValue != 0))
            
            VStack(alignment: .leading, spacing: 8) {
                content
                if progressValue != 0 {
                    ProgressView(value: progressValue)
                        .accentColor(.white)
                        .frame(maxWidth: 132)
                }
            }
            Spacer()
        }
    }
}

struct SectionImageRow_Previews: PreviewProvider {
    static var previews: some View {
        SectionImageRow(imageName: "Logo Ferrari", circleValue: 0.5, progressValue: 0.8, content: {
            Text("Thomas - VW")
                .font(.caption.weight(.medium))
                .foregroundStyle(.secondary)
            Text("Stadtfahrt")
                .fontWeight(.semibold)
            Text("Am 01.01.2022 wurden 5.00km für 2.20€ zurückgelegt.")
                .font(.caption.weight(.medium))
                .foregroundStyle(.secondary)
        })
        .environmentObject(Model())
    }
}
