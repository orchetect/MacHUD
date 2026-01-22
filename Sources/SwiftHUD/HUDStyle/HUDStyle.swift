//
//  HUDStyle.swift
//  swift-hud • https://github.com/orchetect/swift-hud
//

import Foundation

public struct HUDStyle {
    /// The amount of time for the HUD alert to persist on screen before it is dismissed.
    public var stickyTime: TimeInterval
    
    /// Position on screen for the HUD to appear.
    public var position: Position
    
    /// HUD size.
    public var size: Size
    
    /// Background visual shading of the HUD alert.
    public var shade: Shade
    
    /// Boolean determining whether the HUD alert will have a visual border.
    public var isBordered: Bool
    
    /// Fade-out behavior when the alert is dismissed from the screen.
    public var fadeOut: Fade
    
    public init(
        stickyTime: TimeInterval,
        position: Position,
        size: Size,
        shade: Shade,
        isBordered: Bool,
        fadeOut: Fade
    ) {
        self.stickyTime = stickyTime
        self.position = position
        self.size = size
        self.shade = shade
        self.isBordered = isBordered
        self.fadeOut = fadeOut
    }
    
    /// Initializes with custom values, defaulting `nil` parameters to appropriate values for the current platform.
    @_disfavoredOverload
    public init(
        stickyTime: TimeInterval? = nil,
        position: Position? = nil,
        size: Size? = nil,
        shade: Shade? = nil,
        isBordered: Bool? = nil,
        fadeOut: Fade? = nil
    ) {
        self.stickyTime = stickyTime ?? Self.currentPlatform.stickyTime
        self.position = position ?? Self.currentPlatform.position
        self.size = size ?? Self.currentPlatform.size
        self.shade = shade ?? Self.currentPlatform.shade
        self.isBordered = isBordered ?? Self.currentPlatform.isBordered
        self.fadeOut = fadeOut ?? Self.currentPlatform.fadeOut
    }
}

extension HUDStyle: Equatable {}

extension HUDStyle: Hashable {}

extension HUDStyle: Sendable {}
