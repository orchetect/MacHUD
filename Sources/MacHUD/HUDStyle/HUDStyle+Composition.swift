//
//  HUDStyle+Composition.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation

extension HUDStyle {
    /// Returns the style updating the ``transitionIn`` property value.
    public func transitionIn(_ value: HUDTransition?) -> Self {
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
    public func transitionOut(_ value: HUDTransition?) -> Self {
        var copy = self
        copy.transitionOut = value
        return copy
    }
    
    /// Returns the style updating the ``imageAnimationDelay`` property value.
    public func imageAnimationDelay(_ value: TimeInterval?) -> Self {
        var copy = self
        copy.imageAnimationDelay = value
        return copy
    }
}

#endif
