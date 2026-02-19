//
//  ProminentHUDAlertContent.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import SwiftUI

extension ProminentHUDStyle {
    public enum AlertContent: HUDAlertContent {
        case text(String, subtitle: String? = nil)
        
        case image(HUDImageSource)
        case imageAndText(image: HUDImageSource, title: String, subtitle: String? = nil)
        case imageAndProgress(image: HUDImageSource, value: HUDSteppedProgressValue)
        case imageAndTextAndProgress(image: HUDImageSource, title: String, subtitle: String? = nil, value: HUDSteppedProgressValue)
    }
}

// MARK: - Static Constructors

extension ProminentHUDStyle.AlertContent {
    /// Alert that simulates the macOS system audio device volume level change HUD alert.
    ///
    /// - Parameters:
    ///   - level: Audio level.
    ///   - dynamicImage: If `true`, an image corresponding to the volume level is used.
    ///     If `false`, a standard static image is used mimicking macOS system behavior.
    public static func audioVolume(level: HUDProgressValue, dynamicImage: Bool = false) -> Self {
        .imageAndProgress(
            image: .static(.image(forVolumeLevel: dynamicImage ? level.unitInterval : 1.0)),
            value: level.stepped(.segmentCount(ProminentHUDStyle.Geometry.standardSegmentCount))
        )
    }
    
    /// Alert that simulates the macOS system screen brightness level change HUD alert.
    ///
    /// - Parameters:
    ///   - level: Screen brightness level.
    public static func screenBrightness(level: HUDProgressValue) -> Self {
        .imageAndProgress(
            image: .static(.symbol(systemName: "sun.max")),
            value: level.stepped(.segmentCount(ProminentHUDStyle.Geometry.standardSegmentCount))
        )
    }
}

#endif
