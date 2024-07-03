import SwiftUI

struct ErrorModel {
    let title: LocalizedStringKey
    let subtitle: LocalizedStringKey

    static var defaultError: ErrorModel {
        ErrorModel(
            title: "ERROR_TITLE_DEFAULT",
            subtitle: "ERROR_MESSAGE_DEFAULT")
    }
}

