//
//  DefaultHUDStyle.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation

/// Default HUD style appropriate for the current platform.
public struct DefaultHUDStyle: HUDStyle {
    public var transitionIn: HUDTransition?
    public var duration: TimeInterval
    public var transitionOut: HUDTransition?
    public var imageAnimationDelay: TimeInterval?
    
    public init() {
        transitionIn = Self.defaultTransitionIn
        duration = Self.defaultDuration
        transitionOut = Self.defaultTransitionOut
        imageAnimationDelay = Self.defaultImageAnimationDelay
    }
    
    public init(
        transitionIn: HUDTransition?,
        duration: TimeInterval,
        transitionOut: HUDTransition?,
        imageAnimationDelay: TimeInterval? = nil
    ) {
        self.transitionIn = transitionIn
        self.duration = duration
        self.transitionOut = transitionOut
        self.imageAnimationDelay = imageAnimationDelay ?? Self.defaultImageAnimationDelay
    }
}

extension DefaultHUDStyle: Equatable { }

extension DefaultHUDStyle: Hashable { }

extension DefaultHUDStyle: Sendable { }

// MARK: - Platform Defaults

extension DefaultHUDStyle {
    static var defaultTransitionIn: HUDTransition? {
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
    
    static var defaultTransitionOut: HUDTransition? {
        if #available(macOS 26.0, *) {
            MenuPopoverHUDStyle().transitionOut
        } else {
            ProminentHUDStyle().transitionOut
        }
    }
    
    static var defaultImageAnimationDelay: TimeInterval? {
        if #available(macOS 26.0, *) {
            MenuPopoverHUDStyle().imageAnimationDelay
        } else {
            ProminentHUDStyle().imageAnimationDelay
        }
    }
}

#endif
