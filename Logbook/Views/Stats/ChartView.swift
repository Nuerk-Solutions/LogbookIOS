//
//  ChartView.swift
//  Logbook
//
//  Created by Thomas Nürk on 03.01.24.
//

import SwiftUI
import Charts

struct ChartView: View {
    
    @State var refuelEntries: LogbookRefuelReceive = calculateTrend()
    @State var barSelection: String?
    
    let dayAndMonth: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM"
        return dateFormatter
    }()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 12) {
                let totalAverageConsumption = refuelEntries.refuels.reduce(0.0) { partialResult, item in
                    item.refuel.consumption + partialResult
                } / Double(refuelEntries.refuels.count)
                
                let maxYScale = refuelEntries.refuels.max { item1, item2 in
                    return Int(round(item2.refuel.consumption / 2.0)) * 2 > Int(round(item1.refuel.consumption / 2.0)) * 2
                }?.refuel.consumption ?? 15
                
                Text("Ø \(totalAverageConsumption, specifier: "%.2fL")")
                    .font(.largeTitle.bold())
                    .opacity(barSelection == nil ? 1 : 0)
                Chart {
                    ForEach(refuelEntries.refuels) { item in
                        
//                        .zIndex(1000)
                        
                        
                        BarMark(
                            x: .value("Datum", dayAndMonth.string(from: item.date)),
                            y: .value("Verbrauch", item.refuel.consumption)
                        )
                        .foregroundStyle(Color(.orange).gradient)
                        .cornerRadius(5)
//                        .zIndex(-100)
                        //                    .foregroundStyle(by: .value("Datum", dayAndMonth.string(from: item.date)))
                        

//                        .zIndex(100)
                    }
                    if let barSelection {
                        RuleMark(x: .value("Verbrauch", barSelection))
                            .foregroundStyle(.gray.opacity(0.35))
                            .zIndex(-10)
                            .offset(yStart: -10)
                            .annotation(position: .top, spacing: 0, overflowResolution: .init(x: .fit, y: .disabled)) {
                                if let refuel = refuelEntries.refuels.first(where: {dayAndMonth.string(from: $0.date) == barSelection}) {
                                    ChartAnnotation(date: refuel.date, consumption: refuel.refuel.consumption)
                                }
                            }
                    }
                    
                    RuleMark(y: .value("Ø", totalAverageConsumption))
                        .lineStyle(StrokeStyle(lineWidth: 3))
                        .annotation(position: .top, alignment: .leading) {
                            Text("Ø \(totalAverageConsumption, specifier: "%.2fL")")
                                .font(.headline)
                                .foregroundStyle(.blue)
                        }
                    
                    
                    ForEach(calculateTrend().refuels) { item in
                        LineMark(
                            x: .value("Datum", dayAndMonth.string(from: item.date)),
                            y: .value("Verbrauch", item.sumAverage ?? 0.0)
                        )
                        .symbol {
                            Circle()
                                .fill(Color.pink)
                                .frame(width: 8)
                        }
//                        .foregroundStyle(.green)
                    }
                }
//                .chartXAxis {
//                    AxisMarks(values: .stride(by: .day)) { _ in
//                        AxisTick()
//                        AxisGridLine()
//                        AxisValueLabel(format: .dateTime.weekday(.abbreviated), centered: true)
//                    }
//                }
                .chartYAxisLabel("L/ 100km")
                .chartYScale(domain: 0...(maxYScale > 15 ? 15 : maxYScale + (maxYScale == 10 ? 0 : 1)))
//                .chartYAxis(showAxis ? .automatic : .hidden)
//                .chartXAxis(showAxis ? .automatic : .hidden)
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                .chartXSelection(value: $barSelection.animation(.snappy(duration: 0.2)))
                .chartLegend(position: .bottom, alignment: .leading, spacing: 25)
                .frame(height: 250)
                .padding(.top, 15)
                .onAppear {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        animateGraph()
//                    }
                }
                
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(.white.shadow(.drop(radius: 2)))
            }
            .navigationTitle("Statistiken")
            .padding()
            .animation(.snappy, value: refuelEntries)
        }
    }
    
    func animateGraph(fromChange: Bool = false) {
        for(index, _) in refuelEntries.refuels.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * (fromChange ? 0.03 : 0.05)) {
                withAnimation(fromChange ? .easeInOut(duration: 0.8) : .interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)) {
                    refuelEntries.refuels[index].animated = true
                }
            }
        }
    }
}

#Preview {
    ChartView()
}
