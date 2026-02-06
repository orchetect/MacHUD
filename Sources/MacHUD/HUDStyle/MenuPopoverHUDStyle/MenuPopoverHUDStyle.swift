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
    public var transitionIn: HUDTransition?
    public var duration: TimeInterval
    public var transitionOut: HUDTransition?
    
    public init() {
        self = .macOS26
    }
    
    public init(
        transitionIn: HUDTransition?,
        duration: TimeInterval,
        transitionOut: HUDTransition?
    ) {
        self.transitionIn = transitionIn
        self.duration = duration
        self.transitionOut = transitionOut
    }
}

@available(macOS 26.0, *)
extension MenuPopoverHUDStyle: Equatable { }

@available(macOS 26.0, *)
extension MenuPopoverHUDStyle: Hashable { }

@available(macOS 26.0, *)
extension MenuPopoverHUDStyle: Sendable { }

#endif
