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
}

#endif
