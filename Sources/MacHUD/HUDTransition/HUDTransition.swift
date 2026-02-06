//
//  HUDTransition.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation

/// Visual transition in or out for an on-screen HUD alert.
public enum HUDTransition {
    /// Default transition appropriate for the current platform.
    case `default`
    
    /// Opacity fade.
    case opacity(duration: TimeInterval)
    
    /// No transition. (Immediate)
    case none
}

extension HUDTransition: Equatable { }

extension HUDTransition: Hashable { }

extension HUDTransition: Sendable { }

#endif
