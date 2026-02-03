//
//  HUDWindowContext.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import AppKit
import Foundation
import SwiftUI

/// Reference to the HUD window and pertinent properties in order to help facilitate updating the window.
@MainActor
public class HUDWindowContext {
    /// Reference to the HUD window.
    public let window: NSWindow
    
    /// Reference to the HUD window's inner reusable SwiftUI view.
    public let reusableView: NSHostingView<HUDManager.AlertBaseContentView>
    
    /// The screen where the HUD window will appear.
    public let screen: NSScreen
    
    init(
        window: NSWindow,
        reusableView: NSHostingView<HUDManager.AlertBaseContentView>,
        screen: NSScreen
    ) {
        self.window = window
        self.reusableView = reusableView
        self.screen = screen
    }
}

#endif
