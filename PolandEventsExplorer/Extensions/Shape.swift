import SwiftUI

extension InsettableShape {
    func fill<Fill: ShapeStyle, Stroke: ShapeStyle>(
        _ fillStyle: Fill,
        strokeBorder strokeStyle: Stroke,
        lineWidth: CGFloat = 1
    ) -> some View {
        self
            .strokeBorder(strokeStyle, lineWidth: lineWidth)
            .background(self.fill(fillStyle))
    }
}
