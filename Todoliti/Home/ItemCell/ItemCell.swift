import SwiftUI

struct ItemCell: View {

    enum ItemCellAction {
        case checked
        case tapped
    }

    let model: TodoItem
    let handler: (ItemCellAction) -> Void

    var body: some View {
        HStack {
            Group {
                VStack(alignment: .leading) {
                    Text(model.createdDate.formatted(date: .complete, time: .omitted))
                        .font(.caption)
                        .italic()
                        .foregroundStyle(.secondary)
                    Text(model.title)
                        .font(.subheadline)
                    if let details = model.details {
                        Text(details)
                            .lineLimit(1)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer(minLength: 32)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                handler(.tapped)
            }

            Button {
                handler(.checked)
            } label: {
                checkBoxImage
            }

        }
    }

    @ViewBuilder
    var checkBoxImage: some View {
        switch model.status {
        case .todo:
            Image(systemName: "square")
        case .completed:
            Image(systemName: "checkmark.square.fill")
                .foregroundStyle(.green)
        }
    }
}

#Preview {
    VStack(spacing: 24) {
        ItemCell(model: TodoItem(
            id: UUID(),
            title: "Faire les courses",
            details: "Aller faire les courses chez monoprix et aussi passer chez bricorama",
            createdDate: Date(),
            status: .todo)) { action in
                switch action {
                case .checked:
                    print("checked")
                case .tapped:
                    print("tapped")
                }
            }

        ItemCell(model: TodoItem(
            id: UUID(),
            title: "Promener le chien",
            details: "",
            createdDate: Date(),
            status: .completed)) { _ in
                // ..
            }
    }
    .padding()
}
