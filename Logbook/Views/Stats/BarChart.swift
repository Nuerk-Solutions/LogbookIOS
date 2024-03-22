//
//  ChartView.swift
//  Logbook
//
//  Created by Thomas Nürk on 03.01.24.
//

import SwiftUI
import Charts

struct BarChart: View {
    
//    @State var refuelEntries: LogbookRefuelReceive = calculateTrend()
    @State var barSelection: String?
    @State private var vehicleSelection: VehicleEnum = .Ferrari
    @StateObject private var chartVM: ChartViewModel = ChartViewModel()
    @State private var selection: VehicleEnum?
    @StateObject private var netWorkActivitIndicatorManager = NetworkActivityIndicatorManager()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    StatsTitleComponent(vehicleSelection: $vehicleSelection)
                        .environmentObject(chartVM)
                    
                    var totalAverageConsumption: Double = chartVM.logbooks.average { item in
                        item.refuel?.consumption ?? 0
                    }
                    
                    let maxYScale = chartVM.logbooks.max { item1, item2 in
                        return Int(round((item2.refuel?.consumption!)! / 2.0)) * 2 > Int(round((item1.refuel?.consumption!)! / 2.0)) * 2
                    }?.refuel?.consumption ?? 15
                    
                    Text("Ø \(totalAverageConsumption, specifier: "%.2fL")")
                        .font(.largeTitle.bold())
                        .opacity(barSelection == nil ? 1 : 0)
                    
                    Chart {
                        ForEach(chartVM.logbooks) { item in
                            BarMark(
                                x: .value("Datum", dayAndMonth.string(from: item.date)),
                                y: .value("Verbrauch", item.animated ?? false ? (item.refuel?.consumption!)! : 0.0)
                            )
                            .foregroundStyle(Color(.orange).gradient)
                            .cornerRadius(5)
                        }
                        if let barSelection {
                            RuleMark(x: .value("Verbrauch", barSelection))
                                .foregroundStyle(.gray.opacity(0.35))
                                .zIndex(-10)
                                .offset(yStart: -10)
                                .annotation(position: .top, spacing: 0, overflowResolution: .init(x: .fit, y: .disabled)) {
                                    if let refuel = chartVM.allLogbooks.first(where: { dayAndMonth.string(from: $0.date) == barSelection && $0.vehicle == vehicleSelection}) {
                                        ChartAnnotation(date: refuel.date, consumption: refuel.refuel?.consumption ?? 0.00)
                                    }
                                }
                        }
                        
                        RuleMark(y: .value("Ø", totalAverageConsumption))
                                .lineStyle(StrokeStyle(lineWidth: 3))
                                .foregroundStyle(.gray)
                    }
                    .chartYAxisLabel("L/ 100km")
                    .chartXAxisLabel("Datum", alignment: .bottomTrailing)
                    .chartYScale(domain: 0...(maxYScale > 15 ? 15 : maxYScale))
                    .chartYAxis {
                        AxisMarks(position: .leading)
                    }
                    .chartXAxis {
                        AxisMarks(position: AxisMarkPosition.automatic)
                    }
                    .chartXSelection(value: $barSelection.animation(.snappy(duration: 0.2)))
                    .chartLegend(position: .bottom, alignment: .leading, spacing: 25)
                    .frame(height: 250)
                    .padding(.top, 15)
//                    .padding()
                    .navigationTitle("Statistiken")
//                    .padding()
                    .animation(.snappy, value: chartVM.logbooks)
                    .task {
                        await chartVM.loadLogbooks()
                        
//                                            chartVM.updateLogbooks(for: [.Ferrari])
//                                            await chartVM.loadLogbooks()
                        
                    }
                    .onChange(of: chartVM.logbooks) { oldValue, newValue in
                        if(oldValue.count == 0 && newValue.count != 0) {
                            //                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            chartVM.animateGraph()
                            //                    }
                        }
                        
                    }
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(.regularMaterial.shadow(.drop(radius: 2)))
                }
            }
            
        }
    }
}

#Preview {
    BarChart()
}
