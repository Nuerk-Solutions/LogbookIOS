//
//  AdditionalInformationSelectionComponent.swift
//  Logbook
//
//  Created by Thomas Nürk on 01.01.24.
//

import SwiftUI

struct AddInfoSelectComponent: View {
    
    @State private var selection: Int = -1
    @State private var showSheet: Bool = false
    @Binding var showAddInfoSelection: Bool
    @Binding var newLogbook: LogbookEntry
    
    // Change the opacity based on the selection index
    // The index is based on the additional Information given
    // -1 = No Information
    // 0 = Refuel
    // 1 = Service
    // 2 = Refuel & Service
    var selectionIndex: Int {
        if(newLogbook.refuel != nil && newLogbook.service != nil) {
            return 2
        }
        if(newLogbook.service != nil) {
            return 1
        } 
        if(newLogbook.refuel != nil) {
            return 0
        }
        return -1
    }
    
    var body: some View {
        VStack {
            AlternativeCloseButton {
                withAnimation {
                    showAddInfoSelection.toggle()
                }
            }
            .frame(maxWidth: .infinity, alignment: .topTrailing)
            .padding(.trailing, 20)
            
            Text("Informationstyp")
                .font(.title)
                .bold()
            
            HStack(spacing: 100) {
                RoundedTextButton(iconName: "fuelpump", description: "Tanken", index: 0) {
                    selection = 0
                }
                
                RoundedTextButton(iconName: "wrench.and.screwdriver", description: "Wartung", index: 1) {
                    selection = 1
                }
            }
            .padding(.horizontal, 50)
        }
        .interactiveDismissDisabled()
        .sheet(isPresented: $showSheet, content: {
            AddInfoComponent()
                .presentationCornerRadius(30)
                .presentationBackground(.thinMaterial)
        })
    }
    
    @ViewBuilder
    func AddInfoComponent() -> some View {
        if(selection == 0) {
            RefuelView(price: Int((newLogbook.refuel?.price ?? 0) * 100), liters: Int((newLogbook.refuel?.liters ?? 0) * 100), isSpecial: newLogbook.refuel?.isSpecial ?? false, newLogbook: $newLogbook, showAddInfoSelection: $showAddInfoSelection, showSheet: $showSheet, selection: $selection)
                .interactiveDismissDisabled()
        } else {
            ServiceView(price: Int((newLogbook.service?.price ?? 0) * 100), message: newLogbook.service?.message ?? "", newLogbook: $newLogbook, selection: $selection, showSheet: $showSheet, showAddInfoSelection: $showAddInfoSelection)
                .interactiveDismissDisabled()
        }
    }
    
    @ViewBuilder
    func RoundedTextButton(iconName: String, description: String, index: Int, action: @escaping () -> Void) -> some View {
        VStack {
            Button {
                action()
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showSheet.toggle()
//                }
            } label: {
                Image(systemName: iconName)
                    .resizable()
                    .scaledToFit()
                    .symbolEffect(.variableColor, options: .nonRepeating, isActive: selection == index)
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.blue, lineWidth: 5)
            )
            .opacity(selectionIndex == index || selectionIndex == 2 ? 1 : 0.4) //
            
            Text(description)
                .font(.subheadline)
                .bold()
        }
    }
}

#Preview {
    AddInfoSelectComponent(showAddInfoSelection: .constant(false), newLogbook: .constant(LogbookEntry.previewData.data[0]))
}
