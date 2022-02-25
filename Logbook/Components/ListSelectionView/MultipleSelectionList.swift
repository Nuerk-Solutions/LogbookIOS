//
//  MultipleSelectionList.swift
//  Logbook
//
//  Created by Thomas on 24.02.22.
//

import SwiftUI

struct MultipleSelectionList: View {
    
    @State var driver: [DriverEnum]
    @State var selectedDrivers: [DriverEnum] = []
    @State var vehicle: [VehicleEnum]
    @State var selectedVehicles: [VehicleEnum] = []
    
    @State var local = false
    @Binding var showShare: Bool
    @State private var blurAmount: CGFloat = 0
    
    @StateObject var exportViewModel = ExportViewModel()
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                Section("Fahrer") {
                    ForEach(self.driver, id: \.self) { item in
                        MultipleSelectionRow(title: item.id, isSelected: self.selectedDrivers.contains(item)) {
                            if self.selectedDrivers.contains(item) && self.selectedDrivers.count != 1 {
                                self.selectedDrivers.removeAll(where: { $0 == item })
                            }
                            else {
                                self.selectedDrivers.append(item)
                            }
                        }
                    }
                }
                
                Section("Fahrzeuge") {
                    ForEach(self.vehicle, id: \.self) { item in
                        MultipleSelectionRow(title: item.id, isSelected: self.selectedVehicles.contains(item)) {
                            if self.selectedVehicles.contains(item) && self.selectedVehicles.count != 1 {
                                self.selectedVehicles.removeAll(where: { $0 == item })
                            }
                            else {
                                self.selectedVehicles.append(item)
                            }
                        }
                    }
                }
                
                Button {
                    Task {
                        await exportViewModel.downloadXLSX(driver: selectedDrivers, vehicles: selectedVehicles)
                    }
                    local.toggle()
                } label: {
                    Text("Exportieren")
                        .foregroundColor(.white)
                }
                .sheet(isPresented: $exportViewModel.downloaded, onDismiss: {
                    print("Dismissed SHARE")
                    showShare.toggle()
                }, content: {
                        let documentsURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                        let fireUrl = documentsURL.appendingPathComponent(exportViewModel.mailData.attachments?.first!.fileName ?? "")
                        ShareSheet(activityItems: [fireUrl])
                })
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .buttonStyle(GradientButtonStyle())
                .listRowBackground(Color.clear)

            }
            .overlay(
                Group {
                    if exportViewModel.isLoading {
                        ProgressView()
                    }
                }
            )
            .navigationTitle("Exportoptionen")
        }
    }
}

struct MultipleSelectionList_Previews: PreviewProvider {
    static var previews: some View {
        MultipleSelectionList(driver: [DriverEnum.Thomas], vehicle: [VehicleEnum.VW], showShare: .constant(false))
    }
}

struct GradientButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.white)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(15.0)
            .scaleEffect(configuration.isPressed ? 1.1 : 1.0)
    }
}
