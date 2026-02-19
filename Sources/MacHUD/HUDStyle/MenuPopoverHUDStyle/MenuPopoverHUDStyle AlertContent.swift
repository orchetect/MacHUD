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
        case text(String, subtitle: String? = nil)
        
        /// Image-only HUD alert.
        case image(HUDImageSource)
        
        /// Image and text HUD alert.
        case imageAndText(image: HUDImageSource, title: String, subtitle: String? = nil)
        
        /// Text and progress bar HUD alert.
        ///
        /// - Parameters:
        ///   - title: Text string.
        ///   - subtitle: Optional second line of de-emphasized text.
        ///   - progressValue: Progress bar value.
        ///   - progressImages: Optionally specify minimum and maximum images to display on either side of the progress bar.
        case textAndProgress(
            title: String,
            subtitle: String? = nil,
            progressValue: HUDSteppedProgressValue,
            progressImages: HUDProgressImageSource?
        )
        
        /// Image, text, and progress bar alert.
        ///
        /// - Parameters:
        ///   - image: Main image.
        ///   - title: Text string.
        ///   - subtitle: Optional second line of de-emphasized text.
        ///   - progressValue: Progress bar value.
        ///   - progressImages: Optionally specify minimum and maximum images to display on either side of the progress bar.
        case imageAndTextAndProgress(
            image: HUDImageSource,
            title: String,
            subtitle: String? = nil,
            progressValue: HUDSteppedProgressValue,
            progressImages: HUDProgressImageSource?
        )
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
            title: deviceName,
            subtitle: nil,
            progressValue: level.stepped(.segmentCount(18)), // as seen in macOS 26 volume HUD
            progressImages: .audioVolume
        )
    }
    
    /// Alert that simulates the macOS system screen brightness level change HUD alert.
    ///
    /// - Parameters:
    ///   - displayName: Display (screen) name. (On MacBook Pro, this defaults to "Display" for the internal display.)
    ///   - level: Brightness level.
    public static func screenBrightness(displayName: String = "Display", level: HUDProgressValue) -> Self {
        .textAndProgress(
            title: displayName,
            subtitle: nil,
            progressValue: level.stepped(.segmentCount(18)), // as seen in macOS 26 screen brightness HUD
            progressImages: .screenBrightness
        )
    }
}

#endif
