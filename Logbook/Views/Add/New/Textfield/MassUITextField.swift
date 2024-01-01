//
//  CurrencyUITextField.swift
//  NumberSample
//
//  Created by Benoit Pasquier on 10/2/22.
//

import Foundation
import UIKit
import SwiftUI

class MassUITextField: UITextField {
    @Binding private var value: Int
    private let maxDigigts = 2
    
    init(value: Binding<Int>) {
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
    
    override func removeFromSuperview() {
        print(#function)
    }
    
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
            text = unit(from: decimalValue)
        }
    }
    
    @objc private func editingChanged() {
        if(self.intValue < 100000) {
            text = unit(from: decimal)
        } else {
            text = unit(from: Decimal(self.value) / pow(10, self.maxDigigts))
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
        return textValue.decimal / pow(10, self.maxDigigts)
    }
    
    private var intValue: Int {
        return NSDecimalNumber(decimal: decimal * 100).intValue
    }
    
    private func unit(from decimal: Decimal) -> String {
        return Measurement<UnitVolume>(value: NSDecimalNumber(decimal: decimal).doubleValue, unit: .liters).formatted(.measurement(width: .abbreviated, usage: .asProvided, numberFormatStyle:.number.precision(.fractionLength(self.maxDigigts)).grouping(.never)))
    }
}
