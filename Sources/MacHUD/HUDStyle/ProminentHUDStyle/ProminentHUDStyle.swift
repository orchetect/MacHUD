//
//  ProminentHUDStyle.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation

/// Prominent HUD alert style.
public struct ProminentHUDStyle: HUDStyle {
    /// Position on screen for the HUD to appear.
    public var position: Position
    
    /// HUD size.
    public var size: Size
    
    /// Boolean determining whether the HUD alert will have a visual border.
    public var isBordered: Bool
    
    /// Fade-out behavior when the alert is dismissed from the screen.
    public var transitionIn: HUDTransition
    
    /// The amount of time for the HUD alert to persist on screen before it is dismissed, not including fade-in or
    /// fade-out time.
    public var duration: TimeInterval
    
    /// Fade-out behavior when the alert is dismissed from the screen.
    public var transitionOut: HUDTransition
    
    public init(
        position: Position,
        size: Size,
        isBordered: Bool,
        transitionIn: HUDTransition,
        duration: TimeInterval,
        transitionOut: HUDTransition
    ) {
        self.position = position
        self.size = size
        self.isBordered = isBordered
        self.transitionIn = transitionIn
        self.duration = duration
        self.transitionOut = transitionOut
    }
    
    /// Initializes with custom values, defaulting `nil` parameters to appropriate values for the current platform.
    @_disfavoredOverload
    public init(
        position: Position? = nil,
        size: Size? = nil,
        isBordered: Bool? = nil,
        transitionIn: HUDTransition? = nil,
        duration: TimeInterval? = nil,
        transitionOut: HUDTransition? = nil
    ) {
        self.position = position ?? Self.default().position
        self.size = size ?? Self.default().size
        self.isBordered = isBordered ?? Self.default().isBordered
        self.transitionIn = transitionIn ?? Self.default().transitionIn
        self.duration = duration ?? Self.default().duration
        self.transitionOut = transitionOut ?? Self.default().transitionOut
    }
}

extension ProminentHUDStyle: Equatable { }

extension ProminentHUDStyle: Hashable { }

extension ProminentHUDStyle: Sendable { }

#endif
