//
//  MenuPopoverHUDStyle.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation

/// Menu popover HUD style (macOS 26+).
///
/// These alerts present as popovers below a menubar extra.
/// While in full screen mode, these alerts are centered at the top of the screen instead.
@available(macOS 26.0, *)
public struct MenuPopoverHUDStyle: HUDStyle {
    /// Fade-out behavior when the alert is dismissed from the screen.
    public var transitionIn: HUDTransition
    
    /// The amount of time for the HUD alert to persist on screen before it is dismissed, not including fade-in or
    /// fade-out time.
    public var duration: TimeInterval
    
    /// Fade-out behavior when the alert is dismissed from the screen.
    public var transitionOut: HUDTransition
    
    public init(
        transitionIn: HUDTransition,
        duration: TimeInterval,
        transitionOut: HUDTransition
    ) {
        self.transitionIn = transitionIn
        self.duration = duration
        self.transitionOut = transitionOut
    }
    
    /// Initializes with custom values, defaulting `nil` parameters to appropriate values for the current platform.
    @_disfavoredOverload
    public init(
        transitionIn: HUDTransition? = nil,
        duration: TimeInterval? = nil,
        transitionOut: HUDTransition? = nil
    ) {
        self.transitionIn = transitionIn ?? Self.default().transitionIn
        self.duration = duration ?? Self.default().duration
        self.transitionOut = transitionOut ?? Self.default().transitionOut
    }
}

@available(macOS 26.0, *)
extension MenuPopoverHUDStyle: Equatable { }

@available(macOS 26.0, *)
extension MenuPopoverHUDStyle: Hashable { }

@available(macOS 26.0, *)
extension MenuPopoverHUDStyle: Sendable { }

#endif
