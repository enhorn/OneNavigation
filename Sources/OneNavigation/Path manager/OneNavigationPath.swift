//
//  OneNavigationPath.swift
//  OneNavigation
//
//  Created by Robin Enhorn on 2025-03-24.
//

import SwiftUI

/// Navigation path definition.
public protocol OneNavigationPath: Hashable, Identifiable, Equatable {

    associatedtype Destination: View
    
    /// Destination view contructor.
    /// - Parameter pathManager: Path manager used for the presented view.
    /// - Returns: Destination view.
    @MainActor @ViewBuilder func destination<Path: OneNavigationPath>(using pathManager: OnePathManager<Path>) -> Destination

}

extension OneNavigationPath {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }

}
