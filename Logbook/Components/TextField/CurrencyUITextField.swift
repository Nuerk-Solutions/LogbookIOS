//
//  CurrencyUITextField.swift
//  NumberSample
//
//  Created by Benoit Pasquier on 10/2/22.
//

import Foundation
import UIKit
import SwiftUI

class CurrencyUITextField: UITextField {
    @Binding private var value: Int
    private let formatter: NumberFormatterProtocol

    init(formatter: NumberFormatterProtocol, value: Binding<Int>) {
        self.formatter = formatter
        self._value = value
        super.init(frame: .zero)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: superview)
        addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        addTarget(self, action: #selector(resetSelection), for: .allTouchEvents)
        keyboardType = .numberPad
        textAlignment = .right
        sendActions(for: .editingChanged)
    }

//    override func removeFromSuperview() {
//        print(#function)
//    }

    override func deleteBackward() {
        text = textValue.digits.dropLast().string
        sendActions(for: .editingChanged)
    }

    private func setupViews() {
        tintColor = .clear
        setInitialValue()
    }
    
    private func setInitialValue() {
        if value > 0 {
            let val = Double(value)
            let decimalValue = Decimal(val / 100.0)
            text = currency(from: decimalValue)
        }
    }

    @objc private func editingChanged() {
        if(self.intValue < 1000000) {
            text = currency(from: decimal)
        } else {
            text = currency(from: Decimal(self.value) / pow(10, formatter.maximumFractionDigits)) 
        }
        resetSelection()
        updateValue()
    }

    @objc private func resetSelection() {
        selectedTextRange = textRange(from: endOfDocument, to: endOfDocument)
    }

    private func updateValue() {
        DispatchQueue.main.async { [weak self] in
            self?.value = self?.intValue ?? 0
        }
    }

    private var textValue: String {
        return text ?? ""
    }

    var decimal: Decimal {
      return textValue.decimal / pow(10, formatter.maximumFractionDigits)
    }

    private var intValue: Int {
        return NSDecimalNumber(decimal: decimal * 100).intValue
    }

    private func currency(from decimal: Decimal) -> String {
        return formatter.string(for: decimal) ?? ""
    }
}

extension StringProtocol where Self: RangeReplaceableCollection {
    var digits: Self { filter (\.isWholeNumber) }
}

extension String {
    var decimal: Decimal { Decimal(string: digits) ?? 0 }
}

extension LosslessStringConvertible {
    var string: String { .init(self) }
}
