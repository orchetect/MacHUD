//
//  HUDStyle+Static.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUDStyle {
    /// HUD style matching the current system HUD appearance and behavior.
    public static let currentPlatform: Self = if #available(macOS 11.0, *) {
        macOS11Thru15
    } else if #available(macOS 10.15, *) {
        macOS10_15
    } else {
        macOS10_15
    }
    
    /// HUD style matching macOS 10.15 system HUD appearance and behavior.
    public static let macOS10_15: Self = Self(
        position: .bottom,
        size: .large,
        tint: .dark,
        isBordered: false,
        transitionIn: .fade(duration: 0.05),
        duration: 1.2,
        transitionOut: .fade(duration: 0.8)
    )
    
    /// HUD style matching macOS 11 through 15 system HUD appearance and behavior.
    public static let macOS11Thru15: Self = Self(
        position: .bottom,
        size: .large,
        tint: .dark,
        isBordered: false,
        transitionIn: .fade(duration: 0.05),
        duration: 1.2,
        transitionOut: .fade(duration: 0.8)
    )
}

// MARK: - Composable/Chainable Methods

extension HUDStyle {
    /// Returns the style updating the ``position`` property value.
    public func position(_ value: Position) -> Self {
        var copy = self
        copy.position = value
        return copy
    }
    
    /// Returns the style updating the ``size`` property value.
    public func size(_ value: Size) -> Self {
        var copy = self
        copy.size = value
        return copy
    }
    
    /// Returns the style updating the ``tint`` property value.
    public func tint(_ value: Tint) -> Self {
        var copy = self
        copy.tint = value
        return copy
    }
    
    /// Returns the style updating the ``isBordered`` property value.
    public func isBordered(_ value: Bool) -> Self {
        var copy = self
        copy.isBordered = value
        return copy
    }
    
    /// Returns the style updating the ``transitionIn`` property value.
    public func transitionIn(_ value: Transition) -> Self {
        var copy = self
        copy.transitionIn = value
        return copy
    }
    
    /// Returns the style updating the ``duration`` property value.
    public func duration(_ value: TimeInterval) -> Self {
        var copy = self
        copy.duration = value
        return copy
    }
    
    /// Returns the style updating the ``transitionOut`` property value.
    public func transitionOut(_ value: Transition) -> Self {
        var copy = self
        copy.transitionOut = value
        return copy
    }
}
