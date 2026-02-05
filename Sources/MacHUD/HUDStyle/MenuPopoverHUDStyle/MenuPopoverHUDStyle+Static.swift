//
//  MenuPopoverHUDStyle+Static.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation

// MARK: - Static Constructors

@available(macOS 26.0, *)
extension HUDStyle where Self == MenuPopoverHUDStyle {
    /// Menubar popover HUD style (macOS 26+).
    /// These alerts present as popovers below a menubar extra.
    /// While in full screen mode, these alerts are centered at the top of the screen instead.
    @available(macOS 26.0, *)
    public static func menuPopover(_ style: MenuPopoverHUDStyle = .default()) -> MenuPopoverHUDStyle {
        style
    }
}

@available(macOS 26.0, *)
extension MenuPopoverHUDStyle {
    /// HUD style appropriate for the current platform version.
    public static func `default`() -> Self {
        // if #available(macOS 27.0, *) {
        //    .macOS27
        // } else {
        .macOS26
        // }
    }
    
    /// Prominent HUD style matching macOS 10.15 system HUD appearance and behavior.
    public static var macOS26: Self {
        MenuPopoverHUDStyle(
            transitionIn: .fade(duration: 0.05),
            duration: 1.2,
            transitionOut: .fade(duration: 0.8)
        )
    }
}

#endif
