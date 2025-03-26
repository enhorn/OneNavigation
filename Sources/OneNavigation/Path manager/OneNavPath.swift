//
//  OneNavPath.swift
//  OneNavigation
//
//  Created by Robin Enhorn on 2025-03-24.
//

import SwiftUI

/// Navigation path definition.
public protocol OneNavPath: Hashable, Identifiable, Equatable {

    associatedtype Destination: View

    @MainActor @ViewBuilder func destination<Path: OneNavPath>(using pathManager: OnePathManager<Path>) -> Destination

}

extension OneNavPath {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }

}
