//
//  OneGenericNavStack.swift
//  OneNavigation
//
//  Created by Robin Enhorn on 2025-03-26.
//

import SwiftUI

/// Simplified navigation stack wrapping a ``OneNavigationStack``.
public struct OneNavStack<Root: View>: View {

    let root: (OneErrorManager<OneNavPath>, OnePathManager<OneNavPath>) -> Root

    /// Designated initializer.
    /// - Parameter root: View builder block with error manager & path manager.
    public init(@ViewBuilder root: @escaping (OneErrorManager<OneNavPath>, OnePathManager<OneNavPath>) -> Root) {
        self.root = root
    }

    /// Designated initializer.
    /// - Parameter root: View builder block without parameters.
    public init(@ViewBuilder root: @escaping () -> Root) {
        self.root = { _, _ in root() }
    }

    public var body: some View {
        OneNavigationStack<OneNavPath, Root> { err, path in
            root(err, path)
        }
    }

}

#if DEBUG

#Preview("Generic Nav Stack") {
    OneNavStack { errorManager, pathManager in
        VStack(spacing: .medium) {
            Button("Error") {
                errorManager.showRoot(error: .alert(message: "Hello"))
            }
            Button("Present") {
                pathManager.present(id: "Presented view") {
                    VStack(spacing: .medium) {
                        PushPreview()
                        Button("Dismiss") {
                            pathManager.dismiss() // Parent path manager
                        }
                    }.navigationTitle("Presented")
                }
            }
        }
    }
}

fileprivate struct PushPreview: View {

    @Environment(OnePathManager<OneNavPath>.self) var pathManager
    @Environment(OneErrorManager<OneNavPath>.self) var errorManager

    var body: some View {
        Button("Push") {
            pathManager.push(id: "Pushed view") {
                VStack(spacing: .medium) {
                    Button("Pop") {
                        pathManager.pop()
                    }
                    Button("Error") {
                        errorManager.show(
                            error: .banner(message: "Error banner", dismissType: .automatic),
                            forPath: .identifierOnly("Pushed view")
                        )
                    }
                    Button("Dismiss") {
                        pathManager.dismiss()
                    }
                }.navigationTitle("Pushed")
            }
        }
    }

}

#endif
