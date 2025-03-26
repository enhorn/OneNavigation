//
//  OneDevice.swift
//  OneNavigation
//
//  Created by Robin Enhorn on 2025-03-24.
//

import Foundation
#if os(iOS)
import UIKit
#endif

@MainActor internal enum OneDevice {

    #if os(macOS)
    static let isMacos: Bool = true
    #else
    static let isMacos: Bool = false
    #endif

    #if os(iOS)
    static let iPad: Bool = UIDevice.current.userInterfaceIdiom == .pad
    static let iPhone: Bool = UIDevice.current.userInterfaceIdiom == .phone
    static let isVision: Bool = UIDevice.current.userInterfaceIdiom == .vision
    #else
    static let iPad: Bool = false
    static let iPhone: Bool = false
    static let isVision: Bool = false
    #endif
}
