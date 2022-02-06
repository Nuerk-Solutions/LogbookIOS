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
        let scaleFactor = animatableData
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: -30))
        path.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.maxY * 2),
                          control: CGPoint(x: (rect.maxX * 3) * scaleFactor, y: -600 * scaleFactor))
        return path
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
