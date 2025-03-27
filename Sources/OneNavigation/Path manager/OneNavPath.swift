//
//  OneGenericNavPath.swift
//  OneNavigation
//
//  Created by Robin Enhorn on 2025-03-26.
//

import SwiftUI

/// Generic reusable navigation path.
public struct OneNavPath: OneNavigationPath {

    public let id: String
    let content: () -> AnyView

    public init(id: String, content: @escaping () -> some View) {
        self.id = id
        self.content = { AnyView(content()) }
    }

    public static func path(id: String, content: @escaping () -> some View) -> OneNavPath {
        OneNavPath(id: id, content: content)
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    @MainActor @ViewBuilder public func destination<Path>(using pathManager: OnePathManager<Path>) -> AnyView where Path : OneNavigationPath {
        content()
    }

    public static func identifierOnly(_ id: String) -> OneNavPath {
        path(id: id) { EmptyView() }
    }

}
