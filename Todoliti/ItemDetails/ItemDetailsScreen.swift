import SwiftUI

struct ItemDetailsScreen: View {

    @EnvironmentObject private var viewModel: ItemDetailsScreenViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(viewModel.editingItem.itemModel.status == .completed ? "ITEM_DETAILS_DONE" : "ITEM_DETAILS_TODO")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Divider()

                textField(title: "ITEM_DETAILS_TITLE_PLACEHOLDER", $viewModel.editingItem.editingTitle)
                textField(title: "ITEM_DETAILS_DETAILS_PLACEHOLDER", largeEdit: true, $viewModel.editingItem.editingDetails)

            }.textFieldStyle(.roundedBorder)
        }
        .safeAreaInset(edge: .bottom) {
            HStack {
                Button {
                    // ..
                } label: {
                    Text("DELETE")
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.red)
                }
                .buttonStyle(BorderedProminentButtonStyle())
                .tint(.secondary.opacity(0.2))

                Button {
                    // ..
                } label: {
                    Text("VALIDATE")
                        .frame(maxWidth: .infinity)
                }
                .tint(.green)
                .buttonStyle(BorderedProminentButtonStyle())
            }
        }
        .navigationTitle(viewModel.editingItem.editingTitle)
        .padding()
    }

    private func updateItem() {

    }

    private func textField(title: LocalizedStringKey, largeEdit: Bool = false, _ text: Binding<String>) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.top)
                .lineLimit(2)
            TextField(title, text: text, axis: .vertical)
                .lineLimit(largeEdit ? 8 : 2, reservesSpace: true)
        }
    }
}

#Preview {
    NavigationStack {
        ItemDetailsScreen()
    }.environmentObject(ItemDetailsScreenViewModel(todoItem: TodoItem(
        id: UUID(),
        title: "Appeler le garage et demander quand va-t'on pouvoir récupérer la voiture",
        details: nil,
        createdDate: Date(),
        status: .todo)))
}
