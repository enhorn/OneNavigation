//
//  OneErrorManager.swift
//  OneNavigation
//
//  Created by Robin Enhorn on 2025-03-24.
//

import SwiftUI

/// Error manager for displaying errors.
@MainActor @Observable public final class OneErrorManager<Path: OneNavigationPath>: Observable {

    @MainActor var pathErrors: [Path: [OneDisplayableError]] = [:]
    @MainActor var rootErrors: [OneDisplayableError] = []
    
    /// Displays the error for the given path.
    /// - Parameters:
    ///   - error: Error to display.
    ///   - path: Path to display the error at.
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
    
    /// Displays the error at the rot navigatin path.
    /// - Parameter error: Error to display.
    public func showRoot(error: OneDisplayableError) {
        show(error: error, forPath: nil)
    }
    
    /// Removes the given error.
    /// - Parameter error: Error to remove.
    public func remove(error: OneDisplayableError) {
        if rootErrors.contains(error) {
            rootErrors.removeAll { $0 == error }
        } else {
            for key in pathErrors.keys where pathErrors[key, default: []].contains(error) {
                pathErrors[key]?.removeAll { $0 == error }
            }
        }
    }
    
    /// Removes all errors for all paths.
    public func clear() {
        pathErrors.removeAll()
        rootErrors.removeAll()
    }

}
