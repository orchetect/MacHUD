//
//  HUDStyle.swift
//  swift-hud • https://github.com/orchetect/swift-hud
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

import Foundation

public struct HUDStyle {
    /// Position on screen for the HUD to appear.
    public var position: Position
    
    /// HUD size.
    public var size: Size
    
    /// Background visual shading of the HUD alert.
    public var tint: Tint
    
    /// Boolean determining whether the HUD alert will have a visual border.
    public var isBordered: Bool
    
    /// Fade-out behavior when the alert is dismissed from the screen.
    public var transitionIn: Transition
    
    /// The amount of time for the HUD alert to persist on screen before it is dismissed, not including fade-in or
    /// fade-out time.
    public var duration: TimeInterval
    
    /// Fade-out behavior when the alert is dismissed from the screen.
    public var transitionOut: Transition
    
    public init(
        position: Position,
        size: Size,
        tint: Tint,
        isBordered: Bool,
        transitionIn: Transition,
        duration: TimeInterval,
        transitionOut: Transition
    ) {
        self.position = position
        self.size = size
        self.tint = tint
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
        tint: Tint? = nil,
        isBordered: Bool? = nil,
        transitionIn: Transition? = nil,
        duration: TimeInterval? = nil,
        transitionOut: Transition? = nil
    ) {
        self.position = position ?? Self.currentPlatform.position
        self.size = size ?? Self.currentPlatform.size
        self.tint = tint ?? Self.currentPlatform.tint
        self.isBordered = isBordered ?? Self.currentPlatform.isBordered
        self.transitionIn = transitionIn ?? Self.currentPlatform.transitionIn
        self.duration = duration ?? Self.currentPlatform.duration
        self.transitionOut = transitionOut ?? Self.currentPlatform.transitionOut
    }
}

extension HUDStyle: Equatable { }

extension HUDStyle: Hashable { }

extension HUDStyle: Sendable { }
