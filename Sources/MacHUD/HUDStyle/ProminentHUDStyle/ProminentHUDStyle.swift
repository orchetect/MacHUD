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
    
    public var transitionIn: HUDTransition?
    public var duration: TimeInterval
    public var transitionOut: HUDTransition?
    public var imageAnimationDelay: TimeInterval? = 0.5
    
    public init() {
        self = if #available(macOS 11.0, *) {
            .macOS11Thru15
        } else if #available(macOS 10.15, *) {
            .macOS10_15
        } else {
            .macOS10_15
        }
    }
    
    public init(
        position: Position,
        transitionIn: HUDTransition?,
        duration: TimeInterval,
        transitionOut: HUDTransition?
    ) {
        self.position = position
        self.transitionIn = transitionIn
        self.duration = duration
        self.transitionOut = transitionOut
    }
}

extension ProminentHUDStyle: Equatable { }

extension ProminentHUDStyle: Hashable { }

extension ProminentHUDStyle: Sendable { }

#endif
