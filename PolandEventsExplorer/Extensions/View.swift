import SwiftUI

extension View {
    @ViewBuilder
    func display(if condition: Bool) -> some View {
        if condition {
            self
        }
    }
    
    func defaultShadow(color: Color) -> some View {
        self
            .shadow(color: color.opacity(0.2), radius: 10, x: -5, y: -5)
            .shadow(color: color.opacity(0.3), radius: 5, x: 10, y: 10)
    }
        
    func makeStrokeCircleBackground(
        color: Color,
        size: CGFloat,
        strokeColor: Color,
        lineWidth: CGFloat
    ) -> some View {
        self
            .background {
                Circle()
                    .fill(color, strokeBorder: strokeColor, lineWidth: lineWidth)
                    .frame(width: size, height: size)
            }
    }

    func errorAlert(
        error: Binding<APIError?>,
        onDismiss: (() -> Void)? = nil
    ) -> some View {
        self.alert(isPresented: .constant(error.wrappedValue != nil)) {
            Alert(
                title: Text(StringHandler.ErrorAlert.title),
                message: Text(error.wrappedValue?.errorDescription ?? StringHandler.ErrorAlert.unknownError),
                dismissButton: .default(Text(StringHandler.ErrorAlert.dismissButton)) {
                    error.wrappedValue = nil
                    onDismiss?() 
                }
            )
        }
    }
}
