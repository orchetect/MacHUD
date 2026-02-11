//
//  MenuPopoverHUDStyle AlertContent.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import SwiftUI

@available(macOS 26.0, *)
extension MenuPopoverHUDStyle {
    public enum AlertContent: HUDAlertContent {
        /// Text-only HUD alert.
        case text(String)
        
        /// Image-only HUD alert.
        case image(HUDImageSource)
        
        /// Text and image HUD alert.
        case textAndImage(text: String, image: HUDImageSource)
        
        /// HUD alert including a progress bar.
        /// Value is specified as a floating-point value between `0.0 ... 1.0`.
        case textAndProgress(text: String, value: HUDProgressValue, images: HUDProgressImageSource?)
    }
}

// MARK: - Static Constructors

@available(macOS 26.0, *)
extension MenuPopoverHUDStyle.AlertContent {
    /// Alert that simulates the macOS system audio device volume level change HUD alert.
    ///
    /// - Parameters:
    ///   - deviceName: Audio device name.
    ///   - level: Audio level.
    public static func audioVolume(deviceName: String, level: HUDProgressValue) -> Self {
        .textAndProgress(
            text: deviceName,
            value: level,
            images: .minMax(min: .systemName("speaker.fill"), max: .systemName("speaker.wave.3.fill"))
        )
    }
    
    /// Alert that simulates the macOS system screen brightness level change HUD alert.
    ///
    /// - Parameters:
    ///   - displayName: Display name. (On MacBook Pro, this defaults to "Display" for the internal display.)
    ///   - level: Audio level.
    public static func screenBrightness(displayName: String = "Display", level: HUDProgressValue) -> Self {
        .textAndProgress(
            text: displayName,
            value: level,
            images: .minMax(min: .systemName("sun.min"), max: .systemName("sun.max"))
        )
    }
}

#endif
