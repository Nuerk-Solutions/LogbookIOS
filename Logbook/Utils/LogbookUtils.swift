//
//  LogbookUtils.swift
//  Logbook
//
//  Created by Thomas Nürk on 01.01.24.
//

import Foundation
import SwiftUI
import SwiftUIIntrospect

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

public extension TextField {
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
            
//            if text_field.isFirstResponder {
//                if let scrollView = text_field.superview?.superview?.superview?.superview as? UIScrollView {
//                    
//                    // Calculate the rect of the text field in the coordinate system of the window
//                    let textFieldRect = text_field.convert(text_field.bounds, to: nil)
//                    
//                    // Calculate the rect of the text field relative to the scroll view
//                    let textFieldRectInScrollView = scrollView.convert(textFieldRect, from: nil)
//                    
//                    // Calculate the height of the keyboard
//                    let keyboardHeight = doneToolbar.bounds.height
//                    
//                    // Calculate the visible rect by subtracting the keyboard height from the scroll view's bounds
//                    var visibleRect = scrollView.bounds
//                    visibleRect.size.height -= keyboardHeight + 250
//                    print(keyboardHeight, visibleRect.size.height, scrollView.contentOffset.y)
//                    // Ensure the text field is visible by scrolling if necessary
//                    if !visibleRect.contains(textFieldRectInScrollView) {
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
//                            var contentOffset = scrollView.contentOffset
//                            contentOffset.y += 20
//                            scrollView.setContentOffset(contentOffset, animated: true)
//                        }
//                    }
//                }
//            }
        })
       }
   }

                               
class CustomScrollView: UIScrollView {
    var additionalOffset: CGFloat = 0 // Additional offset to be added

    override func setContentOffset(_ contentOffset: CGPoint, animated: Bool) {
        var adjustedContentOffset = contentOffset
        adjustedContentOffset.y -= additionalOffset // Adjusting content offset

        super.setContentOffset(adjustedContentOffset, animated: animated)
    }
}

//public extension TextField {
//    func addDoneButtonOnKeyboard() -> some View {
//        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)) // Set the height of the toolbar as needed
//        doneToolbar.barStyle = .default
//        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let done: UIBarButtonItem = UIBarButtonItem(title: "Fertig", style: .done, target: nil, action: nil)
//        doneToolbar.items = [flexSpace, done]
//        doneToolbar.sizeToFit()
//        
//        return self.introspect(.textField, on: .iOS(.v15, .v16, .v17), customize: { text_field in
//            text_field.inputAccessoryView = doneToolbar
//            done.target = text_field
//            done.action = #selector(text_field.resignFirstResponder)
//            
//            if text_field.isFirstResponder {
//                // Find the scroll view
//                var responder: UIResponder? = text_field
//                while let r = responder, !(r is UIScrollView) {
//                    responder = r.next
//                }
//                if let scrollView = responder as? UIScrollView {
//                    print(scrollView)
//                    // Calculate the rect of the text field in the coordinate system of the window
//                    let textFieldRect = text_field.convert(text_field.bounds, to: nil)
//                    
//                    // Calculate the rect of the text field relative to the scroll view
//                    let textFieldRectInScrollView = scrollView.convert(textFieldRect, from: nil)
//                    
//                    // Calculate the height of the keyboard
//                    let keyboardHeight = doneToolbar.bounds.height
//                    
//                    // Calculate the visible rect by subtracting the keyboard height from the scroll view's bounds
//                    var visibleRect = scrollView.bounds
//                    visibleRect.size.height -= keyboardHeight + 200
//                    print(visibleRect)
//                    // Ensure the text field is visible by scrolling if necessary
//                    if !visibleRect.contains(textFieldRectInScrollView) {
//                        let scrollPoint = CGPoint(x: 0, y: textFieldRectInScrollView.origin.y - scrollView.contentInset.top - 250)
//                        scrollView.setContentOffset(scrollPoint, animated: true)
//                    }
//                }
//            }
//        })
//    }
//}


//public extension TextField {
//    func addDoneButtonOnKeyboard() -> some View {
//        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)) // Set the height of the toolbar as needed
//        doneToolbar.barStyle = .default
//        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let done: UIBarButtonItem = UIBarButtonItem(title: "Fertig", style: .done, target: nil, action: nil)
//        doneToolbar.items = [flexSpace, done]
//        doneToolbar.sizeToFit()
//        
//        return self.introspect(.textField, on: .iOS(.v15, .v16, .v17), customize: { text_field in
//            text_field.inputAccessoryView = doneToolbar
//            done.target = text_field
//            done.action = #selector(text_field.resignFirstResponder)
//            
//            if text_field.isFirstResponder {
//                // Adjusting the scroll offset
//                if let scrollView = text_field.superview?.superview?.superview?.superview as? UIScrollView {
//                    print("ASDASDASDASDASDASDASDASD")
//                    let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: doneToolbar.bounds.size.height - 50, right: 0)
//                    scrollView.contentInset = contentInsets
//                    scrollView.contentOffset = CGPoint(x: 0, y: 50)
//                    scrollView.scrollIndicatorInsets = contentInsets
//                }
//                
//            }
//        })
//    }
//}


public extension TextEditor
{
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
//public extension View {
//    
//    /// Finds a `UITextField` from a `SwiftUI.TextField`
//    func introspectTextEditor(customize: @escaping (UITextView) -> ()) -> some View {
//        introspect(selector: TargetViewSelector.siblingContainingOrAncestorOrAncestorChild, customize: customize)
//    }
//}

let dayAndMonth: DateFormatter = {
    var dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM"
    return dateFormatter
}()
