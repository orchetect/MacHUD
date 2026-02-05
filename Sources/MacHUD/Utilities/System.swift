//
//  System.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation
import CoreGraphics
import SwiftUI

/// Returns `true` if an application is in full screen mode and it is presented to the user.
/// This effectively means the menubar and dock are hidden.
/// Returns `false` if no applications are in full screen mode, or if an application is in
/// full screen mode but it is not the active space.
///
/// Solution inspired by https://stackoverflow.com/a/79707276/2805570
func isAVisibleAppInFullScreenMode() -> Bool {
    guard let windowsInfo = CGWindowListCopyWindowInfo(.optionOnScreenOnly, kCGNullWindowID) else {
        return false
    }
    
    for case let windowInfo as NSDictionary in (windowsInfo as NSArray)
    where windowInfo[kCGWindowOwnerName] as? String == "Dock"
    {
        let windowLayer = windowInfo[kCGWindowLayer]
        if let layerValue = windowLayer as? Int64,
           layerValue < 0
        {
            return true
        }
    }
    
    return false
}

/// Returns the current system color scheme.
func systemColorScheme() -> ColorScheme {
    switch NSApplication.shared.effectiveAppearance.name {
    case .darkAqua, .vibrantDark: return .dark
    case .aqua, .vibrantLight: return .light
    default:
        assertionFailure("Unable to detect system color scheme. Defaulting to light mode.")
        return .light
    }
}

#endif
