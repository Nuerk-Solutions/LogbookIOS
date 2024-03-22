//
//  SegmentControl.swift
//  Logbook
//
//  Created by Thomas Nürk on 18.02.24.
//

import SwiftUI

struct SegmentControlContainer<T: CaseIterable & RawRepresentable & Equatable>: UIViewRepresentable where T.RawValue == String {
    var items: [T]
    var images: [String] // Image names from your asset catalog
    @Binding var selectedItem: T // Binding to selected item of enum type
    
    func makeUIView(context: Context) -> UISegmentedControl {
        let segmentedControl = UISegmentedControl()
        
        for (index, item) in items.enumerated() {
            let title = item.rawValue
            // Load the image from assets
            if index < images.count, let image = UIImage(named: images[index]) {
                segmentedControl.insertSegment(with: image, at: index, animated: false)
            } else {
                segmentedControl.insertSegment(withTitle: title, at: index, animated: false)
            }
        }
        
        segmentedControl.addTarget(context.coordinator, action: #selector(Coordinator.segmentedControlValueChanged(_:)), for: .valueChanged)
        return segmentedControl
    }
    
    func updateUIView(_ uiView: UISegmentedControl, context: Context) {
        // Map selected item to selectedSegmentIndex
        if let selectedIndex = items.firstIndex(of: selectedItem) {
            uiView.selectedSegmentIndex = selectedIndex
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: SegmentControlContainer
        
        init(_ segmentedControl: SegmentControlContainer) {
            self.parent = segmentedControl
        }
        
        @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
            // Map selectedSegmentIndex to selectedItem
            if let selectedItem = parent.items[exist: sender.selectedSegmentIndex] {
                parent.selectedItem = selectedItem
            }
        }
    }
}
