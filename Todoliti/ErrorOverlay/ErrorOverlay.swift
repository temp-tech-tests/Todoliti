import SwiftUI

struct ErrorOverlay: View {

    let errorModel: ErrorModel

    var body: some View {
        HStack(spacing: .zero) {
            VStack(alignment: .leading) {
                Text(errorModel.title)
                    .font(.headline)
                Text(errorModel.subtitle)
                    .font(.caption)
            }
            Spacer(minLength: .zero)
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.black.opacity(0.8))
        }
        .foregroundStyle(.white)
    }
}

private struct ErrorToastOverlayModifier: ViewModifier {

    @Binding var showOverlay: Bool
    let errorModel: ErrorModel

    func body(content: Content) -> some View {
        content
            .overlay {
                VStack {
                    Spacer()
                    if showOverlay {
                        ErrorOverlay(errorModel: errorModel)
                            .padding()
                            .transition(.asymmetric(
                                insertion: .move(edge: .bottom),
                                removal: .scale(scale: 0.8).combined(with: .opacity)))
                            .task {
                                do {
                                    try await Task.sleep(for: .seconds(3))
                                    showOverlay = false
                                } catch {
                                    showOverlay = false
                                }
                            }
                    }
                }
            }
            .animation(.default, value: showOverlay)
    }
}

extension View {
    func errorToast(model: ErrorModel, show: Binding<Bool>) -> some View {
        self.modifier(ErrorToastOverlayModifier(showOverlay: show, errorModel: model))
    }
}

#Preview {

    @MainActor
    struct Previewer: View {

        @State private var show: Bool = false

        var body: some View {
            ScrollView {
                Button {
                    show.toggle()
                } label: {
                    Text("Toggle overlay")
                        .frame(maxWidth: .infinity)
                }

            }
            .modifier(ErrorToastOverlayModifier(showOverlay: $show, errorModel: .defaultError))
        }
    }

    return Previewer()
}
