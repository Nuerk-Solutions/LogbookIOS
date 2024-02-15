//
//  TestView.swift
//  Logbook
//
//  Created by Thomas Nürk on 14.02.24.
//

import SwiftUI

struct TestView: View {
    @State private var showView: Bool = false
    
    var body: some View {
        VStack {
            SourceView(id: "View 1") {
                Circle()
                    .fill(.red)
                    .frame(width: 50, height: 50)
                    .onTapGesture {
                        showView.toggle()
                    }
            }
        }
        .sheet(isPresented: $showView) {
            DestinationView(id: "View 1") {
                Circle()
                    .fill(.red)
                    .frame(width: 500, height: 500)
                    .onTapGesture {
                        showView.toggle()
                    }
            }
            .padding(15)
            .interactiveDismissDisabled()
        }
        .heroLayer(id: "View 1", animate: $showView) {
            Circle()
                .fill(.red)
        } completion: { status in
            print(status)
        }

    }
}

#Preview {
    TestView()
}
