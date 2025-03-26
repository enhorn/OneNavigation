//
//  OneErrorManager.swift
//  OneNavigation
//
//  Created by Robin Enhorn on 2025-03-24.
//

import SwiftUI

/// Error manager for displaying errors.
@MainActor @Observable public final class OneErrorManager<Path: OneNavPath>: Observable {

    @MainActor var pathErrors: [Path: [OneDisplayableError]] = [:]
    @MainActor var rootErrors: [OneDisplayableError] = []

    public func show(error: OneDisplayableError, forPath path: Path?) {
        if let path {
            var errors = pathErrors[path, default: []]
            if !errors.contains(error) {
                errors.append(error)
                pathErrors[path] = errors
            }
        } else {
            rootErrors.append(error)
            if !rootErrors.contains(error) {
                rootErrors.append(error)
            }
        }
    }

    public func showRoot(error: OneDisplayableError) {
        show(error: error, forPath: nil)
    }

    public func remove(error: OneDisplayableError) {
        if rootErrors.contains(error) {
            rootErrors.removeAll { $0 == error }
        } else {
            for key in pathErrors.keys where pathErrors[key, default: []].contains(error) {
                pathErrors[key]?.removeAll { $0 == error }
            }
        }
    }

    public func clear() {
        pathErrors.removeAll()
        rootErrors.removeAll()
    }

}
