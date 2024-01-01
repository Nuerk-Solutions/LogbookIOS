////
////  StatsView.swift
////  Logbook
////
////  Created by Thomas Nürk on 23.12.23.
////
//
//import SwiftUI
//import Charts
//
//struct StatsModel: Identifiable {
//    var id = UUID()
//    let date: String
//    let verbrauch: Double
//    let vehicle: VehicleEnum
//    var animate: Bool = false
//}
//
//struct StatsView: View {
//    
//    @State var currentVehicle: VehicleEnum = .Ferrari
//    @State var currentActiveItem: LogbookEntry?
//    @State var plotWidth: CGFloat = 0
//    @StateObject var chartViewModel: ChartViewModel = ChartViewModel()
////    @State var data: [StatsModel] = [
////        StatsModel(date: "03.04", verbrauch: 10, vehicle: .Ferrari),
////        StatsModel(date: "10.04", verbrauch: 8.9, vehicle: .VW),
////        StatsModel(date: "15.04", verbrauch: 9, vehicle: .Porsche),
////        StatsModel(date: "15.04", verbrauch: 5, vehicle: .VW),
////        StatsModel(date: "16.04", verbrauch: 15, vehicle: .Porsche),
////        StatsModel(date: "18.04", verbrauch: 4.6, vehicle: .VW),
////        StatsModel(date: "31.04", verbrauch: 12, vehicle: .Ferrari)
////    ]
//    
//    var body: some View {
//        NavigationStack{
//            TabView {
//                ChartView(vehicle: .Ferrari)
//                    .padding(.horizontal, 2)
//                ChartView(vehicle: .VW)
//                    .padding(.horizontal, 2)
//                ChartView(vehicle: .Porsche)
//                    .padding(.horizontal, 2)
//            }
//            .tabViewStyle(.page)
//            .indexViewStyle(.page(backgroundDisplayMode: .always))
//            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
//            .padding()
//            .navigationTitle("Statistken")
//            .onChange(of: currentVehicle) { newValue in
//                chartViewModel.filteredLogbooks = chartViewModel.allLogbooks
//                chartViewModel.filteredLogbooks = chartViewModel.filteredLogbooks.filter({ item in
//                    item.vehicleTyp == newValue
//                })
//                
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
//        }
//        //        VStack {
//        //            Text("Statisitk - 2022")
//        //                .font(.largeTitle)
//        //                .foregroundStyle(.primary)
//        //            Chart(data) {
//        //                BarMark(
//        //                    x: .value("Datum", $0.date),
//        //                    y: .value("Verbrauch l/100km", $0.verbrauch)
//        //                )
//        //                .foregroundStyle(by: .value("Auto", $0.vehicle.rawValue))
//        //                .position(by: .value("Auto", $0.vehicle.rawValue))
//        //            }
//        //            .chartYAxisLabel("L/ 100km")
//        //            .chartYAxis {
//        //                AxisMarks(position: .leading)
//        //            }
//        //            .padding()
//        //                        .chartPlotStyle { chartContent in
//        //                            chartContent
//        //                                .background(Color.secondary.opacity(0.2))
//        //                                .frame(height: 100)
//        //
//        //                        }
//        
//        //        }
//    }
//    
//    @ViewBuilder
//    func ChartView(vehicle: VehicleEnum) -> some View {
//        VStack(alignment: .leading, spacing: 12) {
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
//            
////            let totalFuel = chartViewModel.filteredLogbooks.reduce(0.0) { partialResult, item in
////                Double(item.additionalInformation) ?? 0 + Double(partialResult)
////            }
//            
//            let totalDistance = chartViewModel.filteredLogbooks.reduce(0.0) { partialResult, item in
//                Double(item.distanceSinceLastAdditionalInformation) ?? 0 + Double(partialResult)
//            }
//            
//            Text("Ø \(/*(totalFuel / totalDistance), specifier: "%.2fL"*/totalDistance)")
//                .font(.largeTitle.bold())
//            AnimatedChart()
//        }
//        .onAppear {
//            currentVehicle = vehicle
//        }
//        .padding()
//        .background {
//            RoundedRectangle(cornerRadius: 10, style: .continuous)
//                .fill(.white.shadow(.drop(radius: 2)))
//        }
//    }
//    
//    @ViewBuilder
//    func AnnotationView(currentActiveItem: LogbookEntry) -> some View {
//        VStack(alignment: .leading, spacing: 6) {
//            Text("Verbrauch")
//                .font(.caption)
//                .foregroundStyle(.gray)
//            
//            Text("\(((Double(currentActiveItem.additionalInformation) ?? 0.0 ) / (Double(currentActiveItem.distanceSinceLastAdditionalInformation) ?? 0.0)) * 100)")
//                .font(.title3.bold())
//        }
//        .padding(.horizontal, 10)
//        .padding(.vertical, 4)
//        .background {
//            RoundedRectangle(cornerRadius: 6, style: .continuous)
//                .fill(.white.shadow(.drop(radius: 2)))
//        }
//    }
//    
//    @ViewBuilder
//    func AnimatedChart() -> some View {
////                let max = chartViewModel.filteredLogbooks.max { item1, item2 in
////                    return ((Double(item2.additionalInformation) ?? 0.0 ) / (Double(item2.distanceSinceLastAdditionalInformation) ?? 0.0)) > ((Double(item1.additionalInformation) ?? 0.0 ) / (Double(item1.distanceSinceLastAdditionalInformation) ?? 0.0))
////                } ?? LogbookEntry()
//        
//        Chart {
//            ForEach(chartViewModel.filteredLogbooks) { item in
//                BarMark(
//                    x: .value("Datum", DateFormatter.readableDeShort.string(from: item.date)),
//                    y: .value("Verbrauch l/100km", /*(item.animated ?? false) ? */((Double(item.additionalInformation) ?? 0.0 ) / (Double(item.distanceSinceLastAdditionalInformation) ?? 0.0)) * 100/*: 0.0*/)
//                )
//                //                .foregroundStyle(by: .value("Auto", item.vehicle.rawValue))
//                //                .position(by: .value("Auto", item.vehicle.rawValue))
//                .foregroundStyle(Color(.orange).gradient)
//                
//                if let currentActiveItem,currentActiveItem.id == item.id {
//                    RuleMark(x: .value("Datum", DateFormatter.readableDeShort.string(from: currentActiveItem.date)))
//                        .lineStyle(.init(lineWidth: 2, miterLimit: 2, dash: [2], dashPhase: 5))
//                        .offset(x: ((plotWidth - (CGFloat(chartViewModel.filteredLogbooks.count) * 15))  / CGFloat(chartViewModel.filteredLogbooks.count)) / 2)
//                        .annotation(position: .top) {
//                            AnnotationView(currentActiveItem: currentActiveItem)
//                            
//                        }
//                }
//            }
//        }
//        .chartYAxisLabel("L/ 100km")
//        .chartYAxis {
//            AxisMarks(position: .leading)
//        }
//                .chartYScale(domain: 0...15)
//        .chartOverlay(content: { proxy in
//            GeometryReader { innerProxy in
//                Rectangle()
//                    .fill(.clear).contentShape(Rectangle())
//                    .gesture(DragGesture()
//                        .onChanged({ value in
//                            let location = value.location
//                            
//                            if let date: String = proxy.value(atX: location.x) {
//                                if let currentItem = chartViewModel.filteredLogbooks.first(where: { item in
//                                    DateFormatter.readableDeShort.string(from: item.date) == date
//                                }) {
//                                    self.currentActiveItem = currentItem
//                                    // TODO: Update plotAreaSize ios17
//                                    self.plotWidth = proxy.plotAreaSize.width
//                                }
//                            }
//                            
//                        })
//                            .onEnded({ value in
//                                self.currentActiveItem = nil
//                            })
//                    )
//            }
//        })
//        .frame(height: 250)
//        .onAppear {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
////                animateGraph()
//            }
//        }
//    }
//            
//            func animateGraph(fromChange: Bool = false) {
//                for(index, _) in chartViewModel.filteredLogbooks.enumerated() {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * (fromChange ? 0.03 : 0.05)) {
//                        withAnimation(fromChange ? .easeInOut(duration: 0.8) : .interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)) {
//                            chartViewModel.filteredLogbooks[index].animated = true
//                        }
//                    }
//                }
//
//        }
//}
//
////#Preview {
////    StatsView()
////}
