//
//  OnlyChart.swift
//  Logbook
//
//  Created by Thomas Nürk on 22.03.24.
//

import SwiftUI
import Charts

struct OnlyChart: View {
    @EnvironmentObject private var chartVM: ChartViewModel
    @State var barSelection: String?
    @Binding var vehicleSelection: VehicleEnum
    
    var body: some View {
        Chart {
            ForEach(chartVM.logbooks) { item in
                BarMark(
                    x: .value("Datum", dayAndMonth.string(from: item.date)),
                    y: .value("Verbrauch", item.animated ?? false ? (item.refuel?.consumption!)! : 0.0)
                )
                .foregroundStyle(Color(.orange).gradient)
                .cornerRadius(5)
            }
            
//            .chartYAxisLabel("L/ 100km")
//            .chartXAxisLabel("Datum", alignment: .bottomTrailing)
////            .chartYScale(domain: 15)
//            .chartYAxis {
//                AxisMarks(position: .leading)
//            }
//            .chartXAxis {
//                AxisMarks(position: AxisMarkPosition.automatic)
//            }
//            .chartXSelection(value: $barSelection.animation(.snappy(duration: 0.2)))
//            .chartLegend(position: .bottom, alignment: .leading, spacing: 25)
//            RuleMark(y: .value("Ø", 1))
//                .lineStyle(StrokeStyle(lineWidth: 3))
//                .foregroundStyle(.gray)
//            if let barSelection {
//                RuleMark(x: .value("Verbrauch", barSelection))
//                    .foregroundStyle(.gray.opacity(0.35))
//                    .zIndex(-10)
//                    .offset(yStart: -10)
//                    .annotation(position: .top, spacing: 0, overflowResolution: .init(x: .fit, y: .disabled)) {
//                        if let refuel = chartVM.allLogbooks.first(where: { dayAndMonth.string(from: $0.date) == barSelection && $0.vehicle == vehicleSelection}) {
//                            ChartAnnotation(date: refuel.date, consumption: refuel.refuel?.consumption ?? 0.00)
//                        }
//                    }
//            }
        }
//        .frame(height: 250)
//        .padding(.top, 15)
    }
}

//#Preview {
//    OnlyChart()
//}
