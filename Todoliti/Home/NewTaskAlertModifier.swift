import SwiftUI

struct NewTaskAlertModifier: ViewModifier {

    @Binding var text: String
    @Binding var show: Bool

    let onSubmit: () -> Void

    func body(content: Content) -> some View {
        content
            .alert("HOME_CREATE_TASK_TITLE", isPresented: $show) {
                TextField("HOME_CREATE_TASK_TEXT_PLACEHOLDER", text: $text)
                Button("VALIDATE", action: onSubmit)
            } message: {
                Text("HOME_CREATE_TASK_MESSAGE")
            }
    }

}

extension View {
    func newTaskAlert(text: Binding<String>, show: Binding<Bool>, onSubmit: @escaping () -> Void) -> some View {
        self.modifier(NewTaskAlertModifier(text: text, show: show, onSubmit: onSubmit))
    }
}
