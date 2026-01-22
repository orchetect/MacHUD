//
//  HUD Style+Static.swift
//  swift-hud • https://github.com/orchetect/swift-hud
//

import Foundation

extension HUDStyle {
    /// HUD style matching the current system HUD appearance and behavior.
    public static let currentPlatform: Self = {
        if #available(macOS 11.0, *) {
            return macOS11Thru15
        } else if #available(macOS 10.15, *) {
            return macOS10_15
        } else {
            return macOS10_15
        }
    }()
    
    /// HUD style matching macOS 10.15 system HUD appearance and behavior.
    public static let macOS10_15: Self = Self(
        stickyTime: 1.2,
        position: .bottom,
        size: .large,
        shade: .dark,
        isBordered: false,
        fadeOut: .duration(timeInterval: 0.8)
    )
    
    /// HUD style matching macOS 11 through 15 system HUD appearance and behavior.
    public static let macOS11Thru15: Self = Self(
        stickyTime: 1.2,
        position: .bottom,
        size: .large,
        shade: .dark,
        isBordered: false,
        fadeOut: .duration(timeInterval: 0.8)
    )
}
