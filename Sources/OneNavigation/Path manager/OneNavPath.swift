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
    
    /// Designated initializer.
    /// - Parameters:
    ///   - id: Identifier for the navigation path.
    ///   - content: Content to be displayed.
    public init(id: String, content: @escaping () -> some View) {
        self.id = id
        self.content = { AnyView(content()) }
    }
    
    /// Convenience initializer for a ``OneNavPath``.
    /// - Parameters:
    ///   - id: Identifier for the navigation path.
    ///   - content: Content to be displayed.
    /// - Returns: A configured ``OneNavPath``.
    public static func path(id: String, content: @escaping () -> some View) -> OneNavPath {
        OneNavPath(id: id, content: content)
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    /// Default destination implementation.
    /// - Parameter pathManager: Path manager used for the presented view.
    /// - Returns: Presented content.
    @MainActor @ViewBuilder public func destination<Path>(using pathManager: OnePathManager<Path>) -> AnyView where Path : OneNavigationPath {
        content()
    }
    
    /// Convenience initializer for when only needing the identifier.
    /// - Parameter id: Identifier for the navigation path.
    /// - Returns: Configured ``OneNavPath`` with an empty view.
    public static func identifierOnly(_ id: String) -> OneNavPath {
        path(id: id) { EmptyView() }
    }

}
