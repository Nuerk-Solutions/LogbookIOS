//
//  LogbookUtils.swift
//  Logbook
//
//  Created by Thomas Nürk on 01.01.24.
//

import Foundation
import SwiftUI

func getLogbookForVehicle(lastLogbooks: [LogbookEntry], vehicle: VehicleEnum) -> LogbookEntry? {
    lastLogbooks.first { entry in
        entry.vehicle == vehicle
    }
}

extension LogbookEntry {
    
    var isSubmittable: Bool {
        self.mileAge.new > self.mileAge.current && !self.reason.isEmpty
    }
    
    var distance: Double {
        Double(self.mileAge.new - self.mileAge.current)
    }
    
    var computedDistance: Double {
        distance * self.mileAge.unit.distanceMultiplier
    }
    
    var hasAddInfo: Bool {
        self.service != nil || self.refuel != nil
    }
}

extension UnitEnum {
    
    var distanceMultiplier: Double {
        self == .KM ? 1 : 1.60934
    }
    
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


public extension TextField
{
    @available(*, deprecated)
    func addDoneButtonOnKeyboard() -> some View
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Fertig", style: .done, target: nil, action: nil)
        doneToolbar.items = [flexSpace, done]
        doneToolbar.sizeToFit()
        return self.introspectTextField
        {
            text_field in
            text_field.inputAccessoryView = doneToolbar
            done.target = text_field
            done.action = #selector( text_field.resignFirstResponder )
        }
    }
}

public extension TextEditor
{
    @available(*, deprecated)
    func addDoneButtonOnKeyboard() -> some View
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Fertig", style: .done, target: nil, action: nil)
        doneToolbar.items = [flexSpace, done]
        doneToolbar.sizeToFit()
        return self.introspectTextEditor
        {
            text_field in
            text_field.inputAccessoryView = doneToolbar
            done.target = text_field
            done.action = #selector( text_field.resignFirstResponder )
        }
    }
}
public extension View {
    
    /// Finds a `UITextField` from a `SwiftUI.TextField`
    @available(*, deprecated)
    func introspectTextEditor(customize: @escaping (UITextView) -> ()) -> some View {
        introspect(selector: TargetViewSelector.siblingContainingOrAncestorOrAncestorChild, customize: customize)
    }
}
