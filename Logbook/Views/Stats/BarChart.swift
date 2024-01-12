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
    
    let dayAndMonth: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM"
        return dateFormatter
    }()
    
    var body: some View {
        NavigationStack {
            ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                
                HStack {
                    Text("Verbrauch - \(vehicleSelection.rawValue)")
                            .font(.title2)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
//                            .padding(.leading)
//                            .padding(.bottom, -10)
                    Spacer()
                    if netWorkActivitIndicatorManager.isNetworkActivityIndicatorVisible {
                        ProgressView()
                            .padding(.trailing, 5)
                    }
                    
                    Menu(content: {
                        Picker(selection: $vehicleSelection) {
                            ForEach(VehicleEnum.allCases) { vehicle in
                                HStack {
                                    Image("\(getVehicleIcon(vehicleTyp: vehicle))")
                                        .resizable()
                                        .scaledToFill()
                                    Text(vehicle.rawValue)
                                }
                                .tag(vehicle)
                            }
                        } label: {}
                            .customFont(.body)
                    }, label: {
                        Image(systemName: "car.circle")
                            .resizable()
                            .frame(width: 28, height: 28)
                    })
                    .onChange(of: vehicleSelection) { _ in
                        chartVM.updateLogbooks(for: [vehicleSelection])
                        animateGraph(fromChange: true)
                    }
                }
                .frame(maxWidth: .infinity)
                
                let totalAverageConsumption = chartVM.logbooks.reduce(0.0) { partialResult, item in
                    (item.refuel?.consumption!)! + partialResult
                } / Double(chartVM.logbooks.count)
                
                let maxYScale = chartVM.logbooks.max { item1, item2 in
                    return Int(round((item2.refuel?.consumption!)! / 2.0)) * 2 > Int(round((item1.refuel?.consumption!)! / 2.0)) * 2
                }?.refuel?.consumption ?? 15
                
                Text("Ø \(totalAverageConsumption, specifier: "%.2fL")")
                    .font(.largeTitle.bold())
                    .opacity(barSelection == nil ? 1 : 0)
                Chart {
                    ForEach(chartVM.logbooks) { item in
                        
//                        .zIndex(1000)
                        
                        
                        BarMark(
                            x: .value("Datum", dayAndMonth.string(from: item.date)),
                            y: .value("Verbrauch", item.animated ?? false ? (item.refuel?.consumption!)! : 0.0)
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
//                                print(barSelection)
                                if let refuel = chartVM.allLogbooks.first(where: { dayAndMonth.string(from: $0.date) == barSelection && $0.vehicle == vehicleSelection}) {
                                    ChartAnnotation(date: refuel.date, consumption: refuel.refuel?.consumption ?? 0.00)
                                }
                            }
                    }
                    
                    RuleMark(y: .value("Ø", totalAverageConsumption))
                        .lineStyle(StrokeStyle(lineWidth: 3))
                        .foregroundStyle(.gray)
//                        .annotation(position: .top, alignment: .leading) {
//                            Text("Ø \(totalAverageConsumption, specifier: "%.2fL")")
//                                .font(.headline)
//                        }
                    
                    
//                    ForEach(calculateTrend().refuels) { item in
//                        LineMark(
//                            x: .value("Datum", dayAndMonth.string(from: item.date)),
//                            y: .value("Verbrauch", item.sumAverage ?? 0.0)
//                        )
//                        .symbol {
//                            Circle()
//                                .fill(Color.pink)
//                                .frame(width: 8)
//                        }
////                        .foregroundStyle(.green)
//                    }
                }
//                .chartXAxis {
//                    AxisMarks(values: .stride(by: .day)) { _ in
//                        AxisTick()
//                        AxisGridLine()
//                        AxisValueLabel(format: .dateTime.weekday(.abbreviated), centered: true)
//                    }
//                }
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
//                .chartScrollableAxes(.horizontal)
//                .chartXVisibleDomain(length: 10)
                .frame(height: 250)
                .padding(.top, 15)
            }
            .onChange(of: barSelection, { oldValue, newValu in
                print(oldValue, newValu)
            })
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(.regularMaterial.shadow(.drop(radius: 2)))
            }
            .navigationTitle("Statistiken")
            .padding()
            .animation(.snappy, value: chartVM.logbooks)
            .task {
                    await chartVM.loadLogbooks()
                    
//                    chartVM.updateLogbooks(for: [.Ferrari])
//                    await chartVM.loadLogbooks()
                
            }
            .onChange(of: chartVM.logbooks) { oldValue, newValue in
                if(oldValue.count == 0 && newValue.count != 0) {
                    //                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    animateGraph()
                    //                    }
                }
            }
            }
        }
    }
    
    func animateGraph(fromChange: Bool = false) {
        for(index, _) in chartVM.logbooks.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * (fromChange ? 0.03 : 0.05)) {
                withAnimation(fromChange ? .easeInOut(duration: 0.5) : .interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)) {
                    chartVM.logbooks[index].animated = true
                }
            }
        }
    }
}

#Preview {
    BarChart()
}
