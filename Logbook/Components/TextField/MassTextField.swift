//
//  CurrencyTextField.swift
//  NumberSample
//
//  Created by Benoit Pasquier on 10/2/22.
//

import Foundation
import SwiftUI

struct MassTextField: UIViewRepresentable {

    typealias UIViewType = MassUITextField

    let massField: MassUITextField

    init(value: Binding<Int>) {
        massField = MassUITextField(value: value)
    }

    func makeUIView(context: Context) -> MassUITextField {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: massField.frame.size.width, height: 44))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(title: "Fertig", image: nil, primaryAction: context.coordinator.doneAction)

        toolBar.setItems([spacer, doneButton], animated: true)
        massField.inputAccessoryView = toolBar
        return massField
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    
    class Coordinator: NSObject, UITextFieldDelegate {
        lazy var doneAction = UIAction(handler: doneButtonTapped(action:))

        private func doneButtonTapped(action: UIAction) -> Void {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }

    func updateUIView(_ uiView: MassUITextField, context: Context) { }
}
