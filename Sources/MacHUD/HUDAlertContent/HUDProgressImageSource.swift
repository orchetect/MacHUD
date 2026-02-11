//
//  HUDProgressImageSource.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import SwiftUI

/// Image source(s) for use in HUD alerts that contain a progress bar.
public enum HUDProgressImageSource {
    case minMax(min: HUDImageSource, max: HUDImageSource)
}

extension HUDProgressImageSource: Equatable { }

extension HUDProgressImageSource: Sendable { }

#endif
