//
//  CurrencyTextField.swift
//  NumberSample
//
//  Created by Benoit Pasquier on 10/2/22.
//

import Foundation
import SwiftUI

struct CurrencyTextField: UIViewRepresentable {

    typealias UIViewType = CurrencyUITextField

    let numberFormatter: NumberFormatterProtocol
    let currencyField: CurrencyUITextField

    init(numberFormatter: NumberFormatterProtocol, value: Binding<Int>) {
        self.numberFormatter = numberFormatter
        currencyField = CurrencyUITextField(formatter: numberFormatter, value: value)
    }

    func makeUIView(context: Context) -> CurrencyUITextField {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: currencyField.frame.size.width, height: 44))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(title: "Fertig", image: nil, primaryAction: context.coordinator.doneAction)

        toolBar.setItems([spacer, doneButton], animated: true)
        currencyField.inputAccessoryView = toolBar
        return currencyField
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

    func updateUIView(_ uiView: CurrencyUITextField, context: Context) { }
}

protocol NumberFormatterProtocol: AnyObject {
    
    func string(from number: NSNumber) -> String?
    func string(for obj: Any?) -> String?
    var numberStyle: NumberFormatter.Style { get set }
    var maximumFractionDigits: Int { get set }
}

extension NumberFormatter: NumberFormatterProtocol { }
