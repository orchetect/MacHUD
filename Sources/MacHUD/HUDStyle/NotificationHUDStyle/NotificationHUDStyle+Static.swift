//
//  NotificationHUDStyle+Static.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation

// MARK: - Static Constructors

@available(macOS 26.0, *)
extension HUDStyle where Self == NotificationHUDStyle {
    /// Notification HUD style (macOS 26+).
    @available(macOS 26.0, *)
    public static func notification(_ style: NotificationHUDStyle = .default()) -> NotificationHUDStyle {
        style
    }
}

@available(macOS 26.0, *)
extension NotificationHUDStyle {
    /// HUD style appropriate for the current platform version.
    public static func `default`() -> Self {
        // if #available(macOS 27.0, *) {
        //    .macOS27
        // } else {
            .macOS26
        //}
    }
    
    /// Prominent HUD style matching macOS 10.15 system HUD appearance and behavior.
    public static var macOS26: Self {
        NotificationHUDStyle(
            transitionIn: .fade(duration: 0.05),
            duration: 1.2,
            transitionOut: .fade(duration: 0.8)
        )
    }
}

#endif
