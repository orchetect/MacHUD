//
//  ProminentHUDStyle+Static.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation

// MARK: - Static Constructors

extension HUDStyle where Self == ProminentHUDStyle {
    /// Prominent HUD style (macOS 11 through 15).
    public static func prominent(_ style: ProminentHUDStyle = .default()) -> ProminentHUDStyle {
        style
    }
}

extension ProminentHUDStyle {
    /// HUD style appropriate for the current platform version.
    public static func `default`() -> Self {
        if #available(macOS 11.0, *) {
            macOS11Thru15
        } else if #available(macOS 10.15, *) {
            macOS10_15
        } else {
            macOS10_15
        }
    }
    
    /// Prominent HUD style matching macOS 10.15 system HUD appearance and behavior.
    public static var macOS10_15: Self {
        ProminentHUDStyle(
            position: .bottom,
            size: .large,
            isBordered: false,
            transitionIn: .fade(duration: 0.05),
            duration: 1.2,
            transitionOut: .fade(duration: 0.8)
        )
    }
    
    /// Prominent HUD style matching macOS 11 through 15 system HUD appearance and behavior.
    public static var macOS11Thru15: Self {
        ProminentHUDStyle(
            position: .bottom,
            size: .large,
            isBordered: false,
            transitionIn: .fade(duration: 0.05),
            duration: 1.2,
            transitionOut: .fade(duration: 0.8)
        )
    }
}

#endif
