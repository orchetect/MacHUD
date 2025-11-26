//
//  HUD Methods.swift
//  swift-hud • https://github.com/orchetect/swift-hud
//

import Foundation

extension HUD {
    /// Display a HUD alert on the screen.
    public static func displayAlert(
        _ message: String,
        style: Style = Style()
    ) {
        Task { @MainActor in // we need to do UI stuff on the main thread}
            Manager.shared.newHUDAlert(
                message,
                style: style
            )
        }
    }
}
