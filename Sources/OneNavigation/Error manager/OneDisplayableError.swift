//
//  OneDisplayableError.swift
//  OneNavigation
//
//  Created by Robin Enhorn on 2025-03-24.
//

import SwiftUI
import SFSafeSymbols

/// Available displayable error types.
public enum OneDisplayableError {

    public enum BannerDismissType: Equatable {
        case none, dismiss, automatic(TimeInterval)
        public static var automatic: BannerDismissType { .automatic(3) }
    }

    /// Banner that will be displayed at the top of the view.
    case banner(message: String, icon: SFSymbol? = nil, dismissType: BannerDismissType = .none)

    /// Aler presented in fron of the view.
    case alert(message: String, icon: SFSymbol = .exclamationmarkTriangle)

    /// Confirmation dialog presented in fron of the view.
    case confirmation(message: String, confirmTitle: String, cancel: @MainActor () -> Void = {}, action: @MainActor () -> Void, always: @MainActor () -> Void = {})

}

extension OneDisplayableError: Identifiable, Equatable, CustomStringConvertible {

    public var id: String { description }

    public var description: String {
        switch self {
            case .banner(let message, _, _): return "Banner<\(message)>"
            case .alert(let message, _): return "Alert<\(message)>"
            case .confirmation(let message, _, _, _, _): return "ConfirmationSheet<\(message)>"
        }
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.description == rhs.description
    }

}

internal extension OneDisplayableError {

    var isBanner: Bool {
        switch self {
            case .alert, .confirmation: false
            case .banner: true
        }
    }

    var isSheet: Bool {
        switch self {
            case .alert, .confirmation: true
            case .banner: false
        }
    }

    var message: String {
        switch self {
            case .banner(message: let message, _, _): return message
            case .alert(message: let message, icon: _): return message
            case .confirmation(let message, _, _, _, _): return message
        }
    }

    var icon: SFSymbol {
        switch self {
            case .banner(message: _, let icon, _): return icon ?? .exclamationmarkTriangle
            case .alert(message: _, icon: let icon): return icon
            case .confirmation: return .exclamationmarkTriangle
        }
    }

}
