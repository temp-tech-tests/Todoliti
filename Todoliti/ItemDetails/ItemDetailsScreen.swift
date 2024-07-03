import SwiftUI

struct ItemDetailsScreen: View {

    private enum Field {
        case title
        case details
    }

    @FocusState private var focused: Field?
    @Binding var path: [TodoItem]
    @State private var showDeletionConfirmationDialog: Bool = false
    @EnvironmentObject private var viewModel: ItemDetailsScreenViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {

                ItemDetailsCheckMarkView(status: $viewModel.editingItem.editingStatus)
                    .padding(.vertical)

                Divider()

                textField(title: "ITEM_DETAILS_TITLE_PLACEHOLDER", $viewModel.editingItem.editingTitle)
                    .focused($focused, equals: .title)
                textField(title: "ITEM_DETAILS_DETAILS_PLACEHOLDER", $viewModel.editingItem.editingDetails)
                    .focused($focused, equals: .details)

            }
            .textFieldStyle(.roundedBorder)
            .onSubmit {
                focused = nil
            }
        }
        .scrollDismissesKeyboard(.immediately)
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
        .padding(.horizontal)
        .errorToast(model: .defaultError, show: $viewModel.showError)
    }

    private func textField(title: LocalizedStringKey, _ text: Binding<String>) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.top)
            TextField(title, text: text)
                .submitLabel(.done)
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
