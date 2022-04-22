//
//  InvoiceView.swift
//  Logbook
//
//  Created by Thomas on 22.04.22.
//

import SwiftUI

struct InvoiceView: View {
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 200))], spacing: 15) {
                    ForEach(DriverEnum.allCases, id: \.self) {item in
                        NavigationLink {
                            InvoiceDetailView(driver: item)
                        } label: {
                            VStack {
                                Text(item.rawValue)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 50)
                                    .background(.thinMaterial)
                                    .foregroundColor(.primary)
                                    .shadow(radius: 0)
                            }
                        }.shadow(radius: 5)
                        
                    }
                }
                .padding()
            }
            //        .background(LinearGradient(colors: [.red, .purple, .blue, .indigo], startPoint: .top, endPoint: .bottom))
            .background {
                AnimatedBackground()
                    .edgesIgnoringSafeArea(.all)
                    .blur(radius: 50)
                    .opacity(0.5)
            }
            .navigationTitle("Statistik")
        }
    }
}

struct AnimatedBackground: View {
    @State var start: UnitPoint = .top
    @State var end: UnitPoint = .bottom
    
    let timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    let colors = [Color.white, Color.red, Color.purple, Color.blue, Color.indigo, Color.orange, Color.white]
    
    var body: some View {
        
        LinearGradient(gradient: Gradient(colors: colors), startPoint: start, endPoint: end)
            .onReceive(timer, perform: { _ in
                withAnimation(.easeInOut(duration: 10).repeatForever()) {
                    self.start = .bottom
                    self.end = .leading
                    self.start = .trailing
                    self.start = .bottom
                }
            })
    }
}

struct InvoiceView_Previews: PreviewProvider {
    static var previews: some View {
        InvoiceView()
    }
}
