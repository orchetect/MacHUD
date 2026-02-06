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
    public static func prominent(_ style: ProminentHUDStyle = ProminentHUDStyle()) -> ProminentHUDStyle {
        style
    }
}

extension ProminentHUDStyle {
    /// Prominent HUD style matching macOS 10.15 system HUD appearance and behavior.
    public static var macOS10_15: Self {
        ProminentHUDStyle(
            position: .bottom,
            size: .large,
            isBordered: false,
            transitionIn: .opacity(duration: 0.05),
            duration: 1.2,
            transitionOut: .opacity(duration: 0.8)
        )
    }
    
    /// Prominent HUD style matching macOS 11 through 15 system HUD appearance and behavior.
    public static var macOS11Thru15: Self {
        ProminentHUDStyle(
            position: .bottom,
            size: .large,
            isBordered: false,
            transitionIn: .opacity(duration: 0.05),
            duration: 1.2,
            transitionOut: .opacity(duration: 0.8)
        )
    }
}

#endif
