//
//  ChartView.swift
//  Logbook
//
//  Created by Thomas on 09.09.22.
//

import SwiftUI
import SwiftUICharts

struct ChartView: View {
    
    
    var demoData: [Double] = [8, 10, 50, 20, 2, 4, 6, 12, 9, 2]
    @StateObject private var chartModel = ChartViewModel()
    @State private var data1: [Double] = []
    @State private var data2: [Double] = []
    @State private var data3: [Double] = []
//        .enumerated().compactMap { index, element in index % 3 == 2 ? nil : element }.enumerated().compactMap { index, element in index % 3 == 2 ? nil : element }.enumerated().compactMap { index, element in index % 3 == 2 ? nil : element }.enumerated().compactMap { index, element in index % 3 == 2 ? nil : element }.enumerated().compactMap { index, element in index % 3 == 2 ? nil : element }
    var body: some View {
        ScrollView {
            VStack {
                LineView(data: data1, title: "Ferrari", legend: "KM")
            }
            .padding(.bottom, 400)
            VStack {
                LineView(data: data2, title: "VW", legend: "KM")
                    .padding(.bottom, 400)
            }
            VStack {
                LineView(data: data3, title: "Porsche", legend: "KM")
                    .padding(.bottom, 400)
            }
        }
        .task {
            await chartModel.loadLogbooks()
            data1 = chartModel.allLogbooks.filter({ item in
                item.vehicleTyp == .Ferrari
            }).reversed().map ({
                return Double(Int($0.newMileAge) ?? 0)}).enumerated().compactMap { index, element in index % 3 == 2 ? nil : element }.enumerated().compactMap { index, element in index % 3 == 2 ? nil : element }.enumerated().compactMap { index, element in index % 3 == 2 ? nil : element }.enumerated().compactMap { index, element in index % 3 == 2 ? nil : element }.enumerated().compactMap { index, element in index % 3 == 2 ? nil : element }.enumerated().compactMap { index, element in index % 3 == 2 ? nil : element }
            
            data2 = chartModel.allLogbooks.filter({ item in
                item.vehicleTyp == .VW
            }).reversed().map ({
                return Double(Int($0.newMileAge) ?? 0)}).enumerated().compactMap { index, element in index % 3 == 2 ? nil : element }.enumerated().compactMap { index, element in index % 3 == 2 ? nil : element }.enumerated().compactMap { index, element in index % 3 == 2 ? nil : element }.enumerated().compactMap { index, element in index % 3 == 2 ? nil : element }.enumerated().compactMap { index, element in index % 3 == 2 ? nil : element }.enumerated().compactMap { index, element in index % 3 == 2 ? nil : element }
            
            data3 = chartModel.allLogbooks.filter({ item in
                item.vehicleTyp == .Porsche
            }).reversed().map ({
                return Double(Int($0.newMileAge) ?? 0)}).enumerated().compactMap { index, element in index % 3 == 2 ? nil : element }.enumerated().compactMap { index, element in index % 3 == 2 ? nil : element }.enumerated().compactMap { index, element in index % 3 == 2 ? nil : element }.enumerated().compactMap { index, element in index % 3 == 2 ? nil : element }
        }
        .padding(20)
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView()
    }
}
