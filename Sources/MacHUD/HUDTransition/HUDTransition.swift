//
//  HUDTransition.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation

/// Visual transition in or out for an on-screen HUD alert.
public enum HUDTransition {
    /// Opacity fade.
    case opacity(duration: TimeInterval)

    /// Scale and opacity fade.
    case scaleAndOpacity(scaleFactor: ScaleFactor? = nil, duration: TimeInterval)
}

extension HUDTransition: Equatable { }

extension HUDTransition: Hashable { }

extension HUDTransition: Sendable { }

// MARK: - Properties

extension HUDTransition {
    /// Returns the duration of the transition.
    public var duration: TimeInterval {
        switch self {
        case let .opacity(duration: duration):
            duration
        case let .scaleAndOpacity(scaleFactor: _, duration: duration):
            duration
        }
    }
}

#endif
