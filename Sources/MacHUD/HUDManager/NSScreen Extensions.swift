//
//  NSScreen Extensions.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//

#if os(macOS)

import AppKit

extension NSScreen {
    /// Returns the screen that is appropriate for displaying HUD alerts.
    static var alertScreen: NSScreen {
        get throws {
            // grab first screen (not main).
            // main will reference focused screen if user has "Displays have separate Spaces"
            // enabled in System Preferences -> Mission Control.
            guard let screen: NSScreen = .screens.first ?? .main else {
                throw HUDError.internalInconsistency("Can't get reference to main screen.")
            }
            return screen
        }
    }
    
    var effectiveAlertScreenRect: NSRect {
        // determine maximum size for alert
        let screenRect = visibleFrame
        
        return screenRect
    }
}

#endif
