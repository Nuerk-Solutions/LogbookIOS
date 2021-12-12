//
//  TransitionExtension.swift
//  Logbook
//
//  Created by Thomas on 12.12.21.
//

import Foundation
import SwiftUI


struct ScaledCircle: Shape {
    // This controls the size of the circle inside the
    // drawing rectangle. When it's 0 the circle is
    // invisible, and when it’s 1 the circle fills
    // the rectangle.
    var animatableData: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var bigRect = rect
        bigRect.size.width = bigRect.size.width * 2 * (1-animatableData)
        let maximumCircleRadius = sqrt(bigRect.width * bigRect.width + bigRect.height * bigRect.height) * 1.6
        let circleRadius = maximumCircleRadius * animatableData
        
        let x = bigRect.minX - circleRadius / 2
        let y = bigRect.midY - circleRadius / 2
        
        let circleRect = CGRect(x: x, y: y, width: circleRadius, height: circleRadius)
        
        return Circle().path(in: circleRect)
    }
}

// A general modifier that can clip any view using a any shape.
struct ClipShapeModifier<T: Shape>: ViewModifier {
    let shape: T
    
    func body(content: Content) -> some View {
        content.clipShape(shape)
    }
}

// A custom transition combining ScaledCircle and ClipShapeModifier.
extension AnyTransition {
    static var iris: AnyTransition {
        .modifier(
            active: ClipShapeModifier(shape: ScaledCircle(animatableData: 0)),
            identity: ClipShapeModifier(shape: ScaledCircle(animatableData: 1))
        )
    }
}
