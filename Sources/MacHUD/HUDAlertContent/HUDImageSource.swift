//
//  HUDImageSource.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import SwiftUI

/// Image source for use in HUD alerts.
public enum HUDImageSource {
    case systemName(String)
    case image(Image) // not Hashable
    case nsImage(NSImage)
}

extension HUDImageSource: Equatable { }

extension HUDImageSource: Sendable { }

// MARK: - Helpers

extension HUDImageSource {
    /// Returns the image source as a SwiftUI `Image` instance.
    public var image: Image? {
        switch self {
        case let .systemName(systemName):
            if #available(macOS 11, *) {
                Image(systemName: systemName)
            } else {
                // TODO: needs implementation on macOS 10.15
                nil
            }
            
        case let .image(image):
            image
            
        case let .nsImage(nsImage):
            Image(nsImage: nsImage)
        }
    }
}

#endif
