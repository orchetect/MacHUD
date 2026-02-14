//
//  HUDManager Alert Phase.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import AppKit
import SwiftUI

extension HUDManager {
    /// Alert display phase.
    enum AlertPhase: Int {
        case inactive
        case preparingWindow
        case transitioningIn
        case staticallyDisplayed
        case transitioningOut
    }
}

extension HUDManager.AlertPhase: Equatable { }

extension HUDManager.AlertPhase: Hashable { }

extension HUDManager.AlertPhase: CaseIterable { }

extension HUDManager.AlertPhase: Sendable { }

#endif
