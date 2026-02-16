//
//  MenuPopoverHUDStyle+Composition.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import AppKit
import Foundation

// MARK: - Composable/Chainable Methods

@available(macOS 26.0, *)
extension MenuPopoverHUDStyle {
    /// Returns the style updating the ``statusItem`` property value.
    public func statusItem(_ closure: @autoclosure @escaping @MainActor () -> NSStatusItem?) -> Self {
        var copy = self
        copy.statusItem = closure
        return copy
    }
    
    /// Returns the style updating the ``statusItem`` property value.
    public func statusItem(_ closure: (@MainActor () -> NSStatusItem?)? = nil) -> Self {
        var copy = self
        copy.statusItem = closure
        return copy
    }
}

#endif
