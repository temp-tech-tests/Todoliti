//
//  ItemDetailsCheckMarkView.swift
//  Todoliti
//
//  Created by Gautier BILLARD on 03/07/2024.
//

import SwiftUI

struct ItemDetailsCheckMarkView: View {

    @Binding var status: TodoItemStatus

    var body: some View {
        HStack {
            Text("ITEM_DETAILS_STATUS_VIEW_TITLE")
            Spacer()
            Button {
                withAnimation {
                    status = status.toggle()
                }
            } label: {
                Label("", systemImage: status == .completed ? "checkmark.square.fill" : "square")
            }
            .contentTransition(.symbolEffect(.replace))
            .font(.headline)
            .foregroundStyle(status == .completed ? .green : .primary)
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.quaternary)
        }
    }
}

#Preview {

    @MainActor
    struct Previewer: View {

        @State private var status = TodoItemStatus.todo

        var body: some View {
            ItemDetailsCheckMarkView(status: $status)
                .padding()
        }
    }

    return Previewer()
}
