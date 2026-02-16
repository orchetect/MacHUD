//
//  HUDProgressImageSource.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import SwiftUI

/// Image source(s) for use in HUD alerts that contain a progress bar.
public enum HUDProgressImageSource {
    case minMax(min: HUDStaticImageSource, max: HUDStaticImageSource)
}

extension HUDProgressImageSource: Equatable { }

extension HUDProgressImageSource: Sendable { }

// MARK: - Static Constructors

extension HUDProgressImageSource {
    /// Audio device volume level images.
    public static var audioVolume: Self {
        .minMax(
            min: .symbol(systemName: "speaker.fill"),
            max: .symbol(systemName: "speaker.wave.3.fill")
        )
    }
    
    /// Screen brightness level images.
    public static var screenBrightness: Self {
        .minMax(
            min: .symbol(systemName: "sun.min.fill"),
            max: .symbol(systemName: "sun.max.fill")
        )
    }
}

#endif
