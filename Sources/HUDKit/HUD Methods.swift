//
//  HUD Methods.swift
//  HUDKit • https://github.com/orchetect/HUDKit
//

import Foundation

extension HUD {
    /// Display a HUD alert on the screen.
    public static func displayAlert(
        _ message: String,
        style: Style = Style()
    ) {
        // we need to do UI stuff on the main thread
        DispatchQueue.main.async {
            autoreleasepool {
                Manager.shared.newHUDAlert(
                    message,
                    style: style
                )
            }
        }
    }
}
