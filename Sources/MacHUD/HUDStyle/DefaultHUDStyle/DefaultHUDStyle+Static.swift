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
    public static func platformDefault(_ style: DefaultHUDStyle = .default()) -> DefaultHUDStyle {
        style
    }
}

extension DefaultHUDStyle {
    /// HUD style appropriate for the current platform version.
    public static func `default`() -> Self {
        if #available(macOS 26.0, *) {
            let style = MenuPopoverHUDStyle()
            return DefaultHUDStyle(
                transitionIn: style.transitionIn,
                duration: style.duration,
                transitionOut: style.transitionOut
            )
        } else {
            let style = ProminentHUDStyle()
            return DefaultHUDStyle(
                transitionIn: style.transitionIn,
                duration: style.duration,
                transitionOut: style.transitionOut
            )
        }
    }
}

#endif
