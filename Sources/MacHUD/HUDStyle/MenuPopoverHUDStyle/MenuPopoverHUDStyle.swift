//
//  MenuPopoverHUDStyle.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import AppKit
import Foundation

/// Menu popover HUD style (macOS 26+).
///
/// These alerts present as popovers below a menubar extra.
/// While in full screen mode, these alerts are centered at the top of the screen instead.
@available(macOS 26.0, *)
public struct MenuPopoverHUDStyle: HUDStyle {
    public var transitionIn: HUDTransition?
    public var duration: TimeInterval
    public var transitionOut: HUDTransition?
    // a small delay allows HUD window to transition in partly before image animation begins
    public var imageAnimationDelay: TimeInterval? = 0.2
    
    public var statusItem: (@MainActor () -> NSStatusItem?)?
    
    public init() {
        self = .macOS26()
    }
    
    public init(
        transitionIn: HUDTransition?,
        duration: TimeInterval,
        transitionOut: HUDTransition?,
        statusItem: @autoclosure @escaping @MainActor () -> NSStatusItem?
    ) {
        self.transitionIn = transitionIn
        self.duration = duration
        self.transitionOut = transitionOut
        self.statusItem = statusItem
    }
}

@available(macOS 26.0, *)
extension MenuPopoverHUDStyle: Equatable {
    public static func == (lhs: MenuPopoverHUDStyle, rhs: MenuPopoverHUDStyle) -> Bool {
        lhs.transitionIn == rhs.transitionIn
            && lhs.duration == rhs.duration
            && lhs.transitionOut == rhs.transitionOut
            && lhs.imageAnimationDelay == rhs.imageAnimationDelay
            && (lhs.statusItem != nil) == (rhs.statusItem != nil) // can't compare closures, so just check for nil
    }
}

@available(macOS 26.0, *)
extension MenuPopoverHUDStyle: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(transitionIn)
        hasher.combine(duration)
        hasher.combine(transitionOut)
        hasher.combine(imageAnimationDelay)
        hasher.combine(statusItem != nil) // can't hash a closure, so just check for nil
    }
}

@available(macOS 26.0, *)
extension MenuPopoverHUDStyle: Sendable { }

#endif
