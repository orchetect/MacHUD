//
//  DefaultHUDStyle.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation

/// Default HUD style appropriate for the current platform.
public struct DefaultHUDStyle: HUDStyle {
    /// Fade-out behavior when the alert is dismissed from the screen.
    public var transitionIn: HUDTransition
    
    /// The amount of time for the HUD alert to persist on screen before it is dismissed, not including fade-in or
    /// fade-out time.
    public var duration: TimeInterval
    
    /// Fade-out behavior when the alert is dismissed from the screen.
    public var transitionOut: HUDTransition
    
    public init() {
        transitionIn = Self.defaultTransitionIn
        duration = Self.defaultDuration
        transitionOut = Self.defaultTransitionOut
    }
    
    public init(
        transitionIn: HUDTransition,
        duration: TimeInterval,
        transitionOut: HUDTransition
    ) {
        self.transitionIn = transitionIn
        self.duration = duration
        self.transitionOut = transitionOut
    }
}

extension DefaultHUDStyle: Equatable { }

extension DefaultHUDStyle: Hashable { }

extension DefaultHUDStyle: Sendable { }

// MARK: - Platform Defaults

extension DefaultHUDStyle {
    static var defaultTransitionIn: HUDTransition {
        if #available(macOS 26.0, *) {
            MenuPopoverHUDStyle().transitionIn
        } else {
            ProminentHUDStyle().transitionIn
        }
    }
    
    static var defaultDuration: TimeInterval {
        if #available(macOS 26.0, *) {
            MenuPopoverHUDStyle().duration
        } else {
            ProminentHUDStyle().duration
        }
    }
    
    static var defaultTransitionOut: HUDTransition {
        if #available(macOS 26.0, *) {
            MenuPopoverHUDStyle().transitionOut
        } else {
            ProminentHUDStyle().transitionOut
        }
    }
}

#endif
