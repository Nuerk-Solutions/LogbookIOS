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
    
    var body: some View {
        VStack {
            Button {
                showAddInfoSelection.toggle()
            } label: {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .frame(width: 36, height: 36)
                    .background(.black)
                    .mask(Circle())
                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 10)
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
        .sheet(isPresented: $showSheet, content: {
            AddInfoComponent()
                .presentationCornerRadius(30)
                .presentationBackground(.thinMaterial)
        })
    }
    
    @ViewBuilder
    func AddInfoComponent() -> some View {
        if(selection == 0) {
            RefuelView(showAddInfoSelection: $showAddInfoSelection, showSheet: $showSheet, selection: $selection)
        } else {
            ServiceView(selection: $selection, showSheet: $showSheet, showAddInfoSelection: $showAddInfoSelection)
        }
    }
    
    @ViewBuilder
    func RoundedTextButton(iconName: String, description: String, index: Int, action: @escaping () -> Void) -> some View {
        VStack {
            Button {
                action()
                showSheet.toggle()
            } label: {
                Image(systemName: iconName)
                    .resizable()
                    .scaledToFit()
                    .symbolEffect(.pulse, isActive: index == selection)
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.blue, lineWidth: 5)
            )
            .opacity(selection == index ? 1 : 0.4)
            
            Text(description)
                .font(.subheadline)
                .bold()
        }
    }
}

#Preview {
    AddInfoSelectComponent(showAddInfoSelection: .constant(false))
}
