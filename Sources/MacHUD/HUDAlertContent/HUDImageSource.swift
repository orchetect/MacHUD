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
    public var image: Image? { // TODO: refactor as non-Optional
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

// MARK: - Static Constructors

extension HUDImageSource {
    /// Returns an appropriate symbol image for the given audio volume level.
    /// Passing `nil` returns an image suitable for a muted audio state.
    public static func image(forVolumeLevel level: Double?) -> Self {
        guard let level else { return .systemName("speaker.slash.fill") }
        
        return switch level {
        case ...0.0: .systemName("speaker.fill")
        case 0.0 ... 0.25: .systemName("speaker.wave.1.fill")
        case 0.25 ... 0.50: .systemName("speaker.wave.2.fill")
        case 0.50 ... 0.75: .systemName("speaker.wave.3.fill")
        default: // case 0.75 ... 1.0
            .systemName("speaker.wave.3.fill")
        }
    }
}

#endif
