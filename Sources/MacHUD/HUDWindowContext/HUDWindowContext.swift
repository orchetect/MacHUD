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
    /// System color scheme.
    public let colorScheme: ColorScheme
    
    /// Reference to the HUD window.
    public let window: NSWindow
    
    /// Reference to the HUD window's inner reusable SwiftUI view.
    public let reusableView: NSHostingView<HUDManager.AlertBaseContentView>
    
    /// The screen where the HUD window will appear.
    public let screen: NSScreen
    
    /// This property will be `true` if the user has entered full screen mode in an application on the main screen.
    public let isAppFullScreen: Bool
    
    init(
        colorScheme: ColorScheme,
        window: NSWindow,
        reusableView: NSHostingView<HUDManager.AlertBaseContentView>,
        screen: NSScreen
    ) {
        self.colorScheme = colorScheme
        self.window = window
        self.reusableView = reusableView
        self.screen = screen
        isAppFullScreen = isAVisibleAppInFullScreenMode()
    }
}

#endif
