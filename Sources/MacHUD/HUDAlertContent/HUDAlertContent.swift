//
//  HUDAlertContent.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation

public protocol HUDAlertContent: Equatable, Sendable {
    /// If image animation is used in the HUD alert content, provide the duration of the animation.
    /// This duration can be approximate.
    var animationDuration: TimeInterval? { get }
}

// MARK: - Default Implementation

extension HUDAlertContent {
    public var animationDuration: TimeInterval? {
        nil
    }
}

#endif
