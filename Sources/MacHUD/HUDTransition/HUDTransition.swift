//
//  HUDTransition.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation

/// Visual transition in or out for an on-screen HUD alert.
public enum HUDTransition {
    /// Opacity fade.
    case opacity(duration: TimeInterval)
    
    /// Scale and opacity fade.
    case scaleAndOpacity(scaleFactor: CGFloat? = nil, duration: TimeInterval)
}

extension HUDTransition: Equatable { }

extension HUDTransition: Hashable { }

extension HUDTransition: Sendable { }

#endif
