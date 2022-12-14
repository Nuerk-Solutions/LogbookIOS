//
//  SectionIconRow.swift
//  Logbook
//
//  Created by Thomas on 18.06.22.
//

import SwiftUI

struct SectionIconRow<Content: View>: View {
    var iconName: String?
    var innerFrame: CGFloat? = 24
    var outerFrame: CGFloat? = 45
    var contentSpacing: CGFloat? = 16
    var shouldSpace: Bool = true
    @State var circleValue: Double?
    @State var progressValue: Double?
    @ViewBuilder var content: Content
    
    @EnvironmentObject private var model: Model
    
    var body: some View {
        HStack(alignment: .top, spacing: contentSpacing) {
            Image(systemName: iconName ?? "flag")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: innerFrame, height: innerFrame)
                .frame(width: outerFrame, height: outerFrame)
                .mask(Circle())
                .padding(6)
                .background(Color(UIColor.systemBackground).opacity(0.3))
                .mask(Circle())
                .overlay(CircularView(value: circleValue ?? 1))
            
            VStack(alignment: .leading, spacing: 8) {
                content
                if progressValue != 0 {
                    ProgressView(value: progressValue)
                        .accentColor(.white)
                        .frame(maxWidth: 132)
                }
            }
            if(shouldSpace) {
                Spacer()
            }
        }
    }
}

struct SectionIconRow_Previews: PreviewProvider {
    static var previews: some View {
        SectionIconRow(iconName: "flag", circleValue: 0.5, progressValue: 0.8, content: {
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
