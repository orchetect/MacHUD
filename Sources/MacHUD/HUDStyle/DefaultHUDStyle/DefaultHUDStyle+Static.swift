//
//  DefaultHUDStyle+Static.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation

// MARK: - Static Constructors

extension HUDStyle where Self == DefaultHUDStyle {
    /// Default HUD style appropriate for the current platform.
    public static func platformDefault(_ style: DefaultHUDStyle = DefaultHUDStyle()) -> DefaultHUDStyle {
        style
    }
}

#endif
