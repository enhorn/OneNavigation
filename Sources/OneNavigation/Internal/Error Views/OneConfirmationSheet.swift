//
//  OneConfirmationSheet.swift
//  OneNavigation
//
//  Created by Robin Enhorn on 2025-03-24.
//

import SwiftUI

internal struct OneConfirmationSheet: View {

    let message: String
    let cancel: Action
    let action: Action
    let always: () -> Void

    init(message: String, cancel: Action, action: Action, always: @escaping () -> Void = {}) {
        self.message = message
        self.cancel = cancel
        self.action = action
        self.always = always
    }

    var body: some View {
        OneSheetView {
            VStack(spacing: .small) {
                Text(message).padding(.vertical, .small)
                OneRoundedButton(title: action.title, style: action.style) {
                    action.action()
                    always()
                }
                OneRoundedButton(title: cancel.title, style: cancel.style) {
                    cancel.action()
                    always()
                }
            }
            .padding(.small)
        }
    }

}

extension OneConfirmationSheet {

    struct Action {
        let title: String
        let style: OneRoundedButton.Style
        let action: () -> Void

        static func primary(_ title: String, action: @escaping () -> Void) -> Action {
            Action(title: title, style: .primary, action: action)
        }

        static func secondary(_ title: String, action: @escaping () -> Void) -> Action {
            Action(title: title, style: .secondary, action: action)
        }

        static func destructive(_ title: String, action: @escaping () -> Void) -> Action {
            Action(title: title, style: .destructive, action: action)
        }

        static func delete(action: @escaping () -> Void) -> Action {
            Action(title: "Delete", style: .destructive, action: action)
        }

        static func cancel(action: @escaping () -> Void) -> Action {
            Action(title: "Cancel", style: .secondary, action: action)
        }

        static var cancel: Action {
            .cancel { }
        }

    }

}

extension View {

    func confirmationSheet(
        isPresented: Binding<Bool>,
        message: String,
        cancel: OneConfirmationSheet.Action,
        action: OneConfirmationSheet.Action,
        always: @escaping () -> Void = {}
    ) -> some View {
        sheet(isPresented: isPresented) {
            OneConfirmationSheet(message: message, cancel: cancel, action: action, always: always)
        }
    }

}

#if DEBUG
#Preview("OneConfirmationSheet") {
    ConfirmationSheetPreview()
}

struct ConfirmationSheetPreview: View {

    @State var showSheet: Bool = false

    var body: some View {
        ZStack(alignment: .center) {
            Button("Show") { showSheet = true }
        }.confirmationSheet(
            isPresented: $showSheet,
            message: "Some message",
            cancel: .cancel {
                showSheet = false
            },
            action: .primary("Primary") {
                showSheet = false
            }
        )
    }

}

#endif
