import SwiftUI

struct ItemDetailsScreen: View {

    @Binding var path: [TodoItem]
    @State private var showDeletionConfirmationDialog: Bool = false
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
        .confirmationDialog("ITEM_SUPPRESSION_CONFIRMATION_TITLE", isPresented: $showDeletionConfirmationDialog) {
            Button("ITEM_DETAILS_CONFIRMATION_DELETE", role: .destructive) {
                Task {
                    await viewModel.deleteItem()
                    path = []
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showDeletionConfirmationDialog.toggle()
                } label: {
                    Image(systemName: "trash")
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                path = []
            } label: {
                Text("ITEM_DETAILS_FINISH")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(BorderedProminentButtonStyle())
        }
        .onChange(of: viewModel.editingItem) { _, _ in
            viewModel.updateModel()
        }
        .navigationTitle(viewModel.editingItem.editingTitle)
        .padding()
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
        ItemDetailsScreen(path: .constant([]))
    }.environmentObject(ItemDetailsScreenViewModel(todoItem: TodoItem(
        id: UUID(),
        title: "Appeler le garage et demander quand va-t'on pouvoir récupérer la voiture",
        details: nil,
        createdDate: Date(),
        status: .todo)))
}
