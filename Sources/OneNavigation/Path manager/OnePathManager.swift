//
//  OnePathManager.swift
//  OneNavigation
//
//  Created by Robin Enhorn on 2025-03-24.
//

import SwiftUI

/// Path manager for pushing, popping and presenting modals.
@MainActor @Observable public final class OnePathManager<Path: OneNavigationPath>: Observable {

    var path: [Path]
    var modal: Modal?
    internal weak var parent: OnePathManager<Path>?
    
    /// Designated initializer.
    /// - Parameter initial: Initial navigation path.
    public init(initial: [Path] = []) {
        self.path = initial
    }
    
    /// Pushes the given navigation path on the managed navigation stack.
    /// - Parameter path: Path to push.
    public func push(_ path: Path) {
        self.path.append(path)
    }
    
    /// Pops the top navigation path.
    /// - Returns: Discarable ``OneNavigationPath`` that was popped.
    @discardableResult public func pop() -> Path? {
        path.popLast()
    }
    
    /// Modally presents a navigation path.
    /// - Parameters:
    ///   - path: Navigation path to present.
    ///   - inNavigationStack: If the presented path should be wrapped in a ``OneNavigationStack``. Defaults to `true`.
    public func present(path: Path, inNavigationStack: Bool = true) {
        modal = Modal(path: path, inNavigationStack: inNavigationStack)
    }
    
    /// Dismisses the currently presented modal, or if no view is presented, will check if self is presented modally and dismiss it self.
    /// - Returns: Discarable ``OneNavigationPath`` that was dismissed.
    @discardableResult public func dismiss() -> Path? {
        if let current = modal?.path {
            modal = nil
            return current
        } else {
            let current = parent?.path.first
            parent?.dismiss()
            return current
        }
    }

}

extension OnePathManager where Path == OneNavPath {
    
    /// Convenience push functions for a navigation stack that uses ``OneNavPath``.
    /// - Parameters:
    ///   - id: Identifier to push.
    ///   - content: Content view to push.
    public func push<Content: View>(id: String, content: @escaping  () -> Content) {
        push(Path(id: id, content: content))
    }
    
    /// Convenience presentation functions for a navigation stack that uses ``OneNavPath``.
    /// - Parameters:
    ///   - id: Identifier to present.
    ///   - inNavigationStack: If the presented path should be wrapped in a ``OneNavigationStack``. Defaults to `true`.
    ///   - content: Content view to present.
    public func present<Content: View>(id: String, inNavigationStack: Bool = true, content: @escaping  () -> Content) {
        present(path: Path(id: id, content: content), inNavigationStack: inNavigationStack)
    }

}

extension OnePathManager {

    internal struct Modal: Identifiable {

        var id: Path.ID
        let path: Path
        let inNavigationStack: Bool

        init(path: Path, inNavigationStack: Bool) {
            self.id = path.id
            self.path = path
            self.inNavigationStack = inNavigationStack
        }

    }

}
