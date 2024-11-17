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
    
    func errorAlert(error: Binding<APIError?>) -> some View {
        self.alert(isPresented: .constant(error.wrappedValue != nil)) {
            Alert(
                title: Text("⚠️ Error ⚠️"),
                message: Text(error.wrappedValue?.errorDescription ?? "Unknown error"),
                dismissButton: .default(Text("OK")) {
                    error.wrappedValue = nil
                }
            )
        }
    }
}
