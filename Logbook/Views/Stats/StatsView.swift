//
//  StatsView.swift
//  Logbook
//
//  Created by Thomas Nürk on 23.12.23.
//

import SwiftUI
import Charts

struct StatsView: View {
    
    @State var currentVehicle: VehicleEnum = .Ferrari
    @State var currentActiveItem: RefuelsRecive?
    @State var plotWidth: CGFloat = 0
    @Binding var refuelEntries: [LogbookRefuelReceive]
//    @StateObject var chartViewModel: ChartViewModel = ChartViewModel()
    
    var body: some View {
        NavigationStack{
            ChartView(vehicle: .Ferrari)
                .padding(.horizontal, 2)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding()
            .navigationTitle("Statistken")
//            .onChange(of: currentVehicle) { newValue in
//                chartViewModel.filteredLogbooks.indices.forEach { item in
//                    chartViewModel.filteredLogbooks[item].animated = false
//                }
//                
////                animateGraph(fromChange: true)
//            }
//            .task {
//                await chartViewModel.loadLogbooks()
//                chartViewModel.filteredLogbooks = chartViewModel.allLogbooks.filter({ item in
//                    item.vehicleTyp == currentVehicle
//                })
//            }
        }
        //        VStack {
        //            Text("Statisitk - 2022")
        //                .font(.largeTitle)
        //                .foregroundStyle(.primary)
        //            Chart(data) {
        //                BarMark(
        //                    x: .value("Datum", $0.date),
        //                    y: .value("Verbrauch l/100km", $0.verbrauch)
        //                )
        //                .foregroundStyle(by: .value("Auto", $0.vehicle.rawValue))
        //                .position(by: .value("Auto", $0.vehicle.rawValue))
        //            }
        //            .chartYAxisLabel("L/ 100km")
        //            .chartYAxis {
        //                AxisMarks(position: .leading)
        //            }
        //            .padding()
        //                        .chartPlotStyle { chartContent in
        //                            chartContent
        //                                .background(Color.secondary.opacity(0.2))
        //                                .frame(height: 100)
        //
        //                        }
        
        //        }
    }
    
    @ViewBuilder
    func ChartView(vehicle: VehicleEnum) -> some View {
        VStack(alignment: .leading, spacing: 12) {
//            HStack {
//                Text("Fahrzeug")
//                    .fontWeight(.semibold)
//                    .padding(.trailing, 25)
//                
//                Picker("", selection: $currentVehicle) {
//                    ForEach(VehicleEnum.allCases.filter({ item in
//                        item != .MX5 && item != .DS
//                    })) { vehicle in
//                        Text(vehicle.rawValue)
//                            .tag(vehicle)
//                    }
//                }
//                .pickerStyle(.segmented)
//            }
            
            let totalAverageConsumption = refuelEntries[0].refuels.reduce(0.0) { partialResult, item in
                item.refuel.consumption + partialResult
            } / Double(refuelEntries[0].refuels.count)
            
            Text("Ø \(totalAverageConsumption, specifier: "%.2fL")")
                .font(.largeTitle.bold())
            AnimatedChart()
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(.white.shadow(.drop(radius: 2)))
        }
    }
    
    @ViewBuilder
    func AnnotationView(currentActiveItem: RefuelsRecive) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Verbrauch")
                .font(.caption)
                .foregroundStyle(.gray)
            
            Text("\(currentActiveItem.refuel.consumption)")
                .font(.title3.bold())
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
        .background {
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .fill(.white.shadow(.drop(radius: 2)))
        }
    }
    
    @ViewBuilder
    func AnimatedChart() -> some View {
        let max = refuelEntries[0].refuels.max { item1, item2 in
            return item2.refuel.consumption > item1.refuel.consumption
        }?.refuel.consumption ?? 15
        
        Chart {
            ForEach(refuelEntries[0].refuels) { item in
                BarMark(
                    x: .value("Datum", DateFormatter.readableDeShort.string(from: item.date)),
                    y: .value("Verbrauch l/100km", /*(item.animated ?? false) ? */item.refuel.consumption/*: 0.0*/)
                )
//                                .foregroundStyle(by: .value("Auto", item.vehicle.rawValue))
//                                .position(by: .value("Auto", item.vehicle.rawValue))
                .foregroundStyle(Color(.orange).gradient)
                
                if let currentActiveItem,currentActiveItem.id == item.id {
                    RuleMark(x: .value("Datum", DateFormatter.readableDeShort.string(from: currentActiveItem.date)))
                        .lineStyle(.init(lineWidth: 2, miterLimit: 2, dash: [2], dashPhase: 5))
//                        .offset(x: ((plotWidth / CGFloat(refuelEntries[0].refuels.count)) - plotWidth / 2))
                        .annotation(position: .top) {
                            AnnotationView(currentActiveItem: currentActiveItem)
                            
                        }
                }
            }
        }
        .chartYAxisLabel("L/ 100km")
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .chartYScale(domain: 0...(1 + max))
        .chartOverlay(content: { proxy in
            GeometryReader { innerProxy in
                Rectangle()
                    .fill(.clear).contentShape(Rectangle())
                    .gesture(DragGesture()
                        .onChanged({ value in
                            let location = value.location
                            
                            if let date: String = proxy.value(atX: location.x) {
                                if let currentItem = refuelEntries[0].refuels.first(where: { item in
                                    DateFormatter.readableDeShort.string(from: item.date) == date
                                }) {
                                    self.currentActiveItem = currentItem
                                    // TODO: Update plotAreaSize ios17
                                    self.plotWidth = proxy.plotSize.width
                                }
                            }
                            
                        })
                            .onEnded({ value in
                                self.currentActiveItem = nil
                            })
                    )
            }
        })
        .frame(height: 250)
//        .onAppear {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                animateGraph()
//            }
//        }
    }
            
//            func animateGraph(fromChange: Bool = false) {
//                for(index, _) in refuelEntries[0].refuels.enumerated() {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * (fromChange ? 0.03 : 0.05)) {
//                        withAnimation(fromChange ? .easeInOut(duration: 0.8) : .interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)) {
//                            chartViewModel.filteredLogbooks[index].animated = true
//                        }
//                    }
//                }
//        }
}

#Preview {
    StatsView(refuelEntries: .constant(LogbookRefuelReceive.previewData))
}
