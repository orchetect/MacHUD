//
//  DefaultHUDStyle.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import AppKit
import Foundation

/// Default HUD style appropriate for the current platform.
public struct DefaultHUDStyle: HUDStyle {
    public var transitionIn: HUDTransition?
    public var duration: TimeInterval
    public var transitionOut: HUDTransition?
    public var imageAnimationDelay: TimeInterval?
    public var statusItem: (@MainActor () -> NSStatusItem?)?
    
    public init() {
        transitionIn = Self.defaultTransitionIn
        duration = Self.defaultDuration
        transitionOut = Self.defaultTransitionOut
        imageAnimationDelay = Self.defaultImageAnimationDelay
        statusItem = nil
    }
    
    public init(
        transitionIn: HUDTransition?,
        duration: TimeInterval,
        transitionOut: HUDTransition?,
        imageAnimationDelay: TimeInterval? = nil,
        statusItem: (@MainActor () -> NSStatusItem?)? = nil
    ) {
        self.transitionIn = transitionIn
        self.duration = duration
        self.transitionOut = transitionOut
        self.imageAnimationDelay = imageAnimationDelay ?? Self.defaultImageAnimationDelay
        self.statusItem = statusItem
    }
}

extension DefaultHUDStyle: Equatable {
    public static func == (lhs: DefaultHUDStyle, rhs: DefaultHUDStyle) -> Bool {
        lhs.transitionIn == rhs.transitionIn
            && lhs.duration == rhs.duration
            && lhs.transitionOut == rhs.transitionOut
            && lhs.imageAnimationDelay == rhs.imageAnimationDelay
            && (lhs.statusItem != nil) == (rhs.statusItem != nil) // can't compare closures, so just check for nil
    }
}

extension DefaultHUDStyle: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(transitionIn)
        hasher.combine(duration)
        hasher.combine(transitionOut)
        hasher.combine(imageAnimationDelay)
        hasher.combine(statusItem != nil) // can't hash a closure, so just check for nil
    }
}

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
