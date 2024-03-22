//
//  TextField+Extension.swift
//  Logbook
//
//  Created by Thomas Nürk on 05.03.24.
//

import SwiftUI

public extension TextField {
    
    @available(*, deprecated, message: "Use default toolbar of SwiftUI")
    
    func addDoneButtonOnKeyboard() -> some View {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)) // Set the height of the toolbar as needed
        doneToolbar.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Fertig", style: .done, target: nil, action: nil)
        doneToolbar.items = [flexSpace, done]
        doneToolbar.sizeToFit()
        
        return self.introspect(.textField, on: .iOS(.v15, .v16, .v17), customize: { text_field in
            text_field.inputAccessoryView = doneToolbar
            
            done.target = text_field
            done.action = #selector(text_field.resignFirstResponder)
        })
       }
   }

public extension TextEditor
{
    @available(*, deprecated, message: "Use default toolbar of SwiftUI")
    func addDoneButtonOnKeyboard() -> some View
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Fertig", style: .done, target: nil, action: nil)
        doneToolbar.items = [flexSpace, done]
        doneToolbar.sizeToFit()
        return self.introspect(.textEditor, on: .iOS(.v15, .v16, .v17), customize: { text_editor in
            text_editor.inputAccessoryView = doneToolbar
            done.target = text_editor
            done.action = #selector( text_editor.resignFirstResponder )
        })
    }
}
