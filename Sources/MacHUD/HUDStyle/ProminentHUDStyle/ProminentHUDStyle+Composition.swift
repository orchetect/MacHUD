//
//  ProminentHUDStyle+Composition.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation

// MARK: - Composable/Chainable Methods

extension ProminentHUDStyle {
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
    
    /// Returns the style updating the ``isBordered`` property value.
    public func isBordered(_ value: Bool) -> Self {
        var copy = self
        copy.isBordered = value
        return copy
    }
    
    /// Returns the style updating the ``transitionIn`` property value.
    public func transitionIn(_ value: HUDTransition) -> Self {
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
    public func transitionOut(_ value: HUDTransition) -> Self {
        var copy = self
        copy.transitionOut = value
        return copy
    }
}

#endif
