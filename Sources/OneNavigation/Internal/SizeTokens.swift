//
//  SizeTokens.swift
//  OneNavigation
//
//  Created by Robin Enhorn on 2025-03-24.
//

#if os(macOS)
import AppKit
#else
import UIKit
#endif
import SwiftUI

internal extension CGFloat {

    #if os(iOS)
    @MainActor static var hairline: CGFloat { 1.0 / UIScreen.main.scale }
    #elseif os(macOS)
    @MainActor static var hairline: CGFloat { 1.0 / (NSScreen.main?.backingScaleFactor ?? 1.0) }
    #endif

    /// 4pt
    static let xxxSmall: CGFloat = 4

    /// 8pt
    static let xxSmall: CGFloat = 8

    /// 12pt
    static let xSmall: CGFloat = 12

    /// 16pt
    static let small: CGFloat = 16

    /// 24pt
    static let medium: CGFloat = 24

    /// 32pt
    static let large: CGFloat = 32

    /// 48pt
    static let xLarge: CGFloat = 48

    /// 56pt
    static let xxLarge: CGFloat = 56

    /// 64pt
    static let xxxLarge: CGFloat = 64

    /// 72pt
    static let xxxxLarge: CGFloat = 72

}
