//
//  OnePathManager.swift
//  OneNavigation
//
//  Created by Robin Enhorn on 2025-03-24.
//

import SwiftUI

/// Path manager for pushing, popping and presenting modals.
@MainActor @Observable public final class OnePathManager<Path: OneNavPath>: Observable {

    var path: [Path]
    var modal: Modal?
    internal weak var parent: OnePathManager<Path>?

    public init(initial: [Path] = []) {
        self.path = initial
    }

    public func push(_ path: Path) {
        self.path.append(path)
    }

    @discardableResult public func pop() -> Path? {
        path.popLast()
    }

    public func present(path: Path, inNavigationStack: Bool = true) {
        modal = Modal(path: path, inNavigationStack: inNavigationStack)
    }

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

extension OnePathManager where Path == OneGenericNavPath {

    public func push<Content: View>(id: String, content: @escaping  () -> Content) {
        push(Path(id: id, content: content))
    }

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
