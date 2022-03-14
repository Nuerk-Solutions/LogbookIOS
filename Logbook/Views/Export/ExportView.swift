//
//  MultipleSelectionList.swift
//  Logbook
//
//  Created by Thomas on 24.02.22.
//

import SwiftUI

struct ExportView: View {
    
    @State var driver: [DriverEnum]
    @State var selectedDrivers: [DriverEnum] = []
    @State var vehicle: [VehicleEnum]
    @State var selectedVehicles: [VehicleEnum] = []
    
    @Binding var showActivitySheet: Bool
    @StateObject var exportViewModel = ExportViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                Section("Fahrer") {
                    ForEach(self.driver, id: \.self) { item in
                        HStack {
                        ExportSelectionRowView(title: item.id, isSelected: self.selectedDrivers.contains(item)) {
                            if self.selectedDrivers.contains(item) {
                                if(self.selectedDrivers.count == 1) {
                                    if(item == self.selectedDrivers.first) {
                                        return
                                    }
                                }
                                self.selectedDrivers.removeAll(where: { $0 == item })
                                print("Remove")
                            }
                            else {
                                self.selectedDrivers.append(item)
                            }
                        }
                        }
                    }
                }
                
                Section("Fahrzeuge") {
                    ForEach(self.vehicle, id: \.self) { item in
                        ExportSelectionRowView(title: item.id, isSelected: self.selectedVehicles.contains(item)) {
                            if self.selectedVehicles.contains(item) {
                                    if(self.selectedVehicles.count == 1) {
                                        if(item == self.selectedVehicles.first) {
                                            return
                                        }
                                    }
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
                        await exportViewModel.downloadXLSX(drivers: selectedDrivers, vehicles: selectedVehicles)
                    }
                } label: {
                    Text("Exportieren")
                        .foregroundColor(.white)
                }
                .sheet(isPresented: $exportViewModel.downloaded, onDismiss: {
                    print("Dismissed SHARE")
                    showActivitySheet.toggle()
                }, content: {
                        let documentsURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                        let fireUrl = documentsURL.appendingPathComponent(exportViewModel.fileName ?? "")
                        ShareSheet(activityItems: [fireUrl])
                })
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .buttonStyle(GradientButtonStyle())
                .listRowBackground(Color.clear)

            }
            .overlay(
                Group {
                    if exportViewModel.isLoading {
                        CustomProgressView(message: "Laden...")
                    }
                }
            )
            .navigationTitle("Exportoptionen")
        }
    }
}

struct ExportView_Previews: PreviewProvider {
    static var previews: some View {
        ExportView(driver: [DriverEnum.Thomas, DriverEnum.Andrea], vehicle: [VehicleEnum.VW], showActivitySheet: .constant(false))
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
