//
//  HUDStaticImageSource.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import SwiftUI

/// Static image source for use in HUD alerts.
public enum HUDStaticImageSource {
    case symbol(HUDStaticSystemImageSource)
    case image(Image) // not Hashable
    case nsImage(NSImage)
}

extension HUDStaticImageSource: Equatable { }

extension HUDStaticImageSource: Sendable { }

// MARK: - Helpers

extension HUDStaticImageSource {
    /// Returns the image source as a SwiftUI `Image` instance.
    public var image: Image? { // TODO: refactor as non-Optional
        switch self {
        case let .symbol(imageSource):
            imageSource.image
            
        case let .image(image):
            image
            
        case let .nsImage(nsImage):
            Image(nsImage: nsImage)
        }
    }
    
    /// Returns the image source as a resizable, scaled-to-fit SwiftUI `Image` instance.
    public var scalableImage: (some View)? { // TODO: refactor as non-Optional
        image?
            .resizable()
            .scaledToFit()
    }
}

// MARK: - Static Constructors

extension HUDStaticImageSource {
    /// System symbol image with optional variable value and rendering mode.
    /// Variable value will only be applied on macOS 13.0+ and rendering mode will only be applied
    /// on macOS 11.0+.
    public static func symbol(
        systemName: String,
        variable: Double? = nil,
        renderingMode: HUDStaticSystemImageSource.RenderingMode? = nil
    ) -> Self {
        .symbol(.systemName(systemName, variable: variable, renderingMode: renderingMode))
    }
    
    
    /// Returns an appropriate system symbol image for the given audio volume level.
    ///
    /// - Parameters:
    ///   - level: Volume level in range `0.0 ... 1.0`. Passing `nil` returns an image suitable for a muted audio state.
    ///   - useVariable: When `true`, for all unmuted audio levels, use the variable fill of the 3-wave speaker symbol.
    ///   - renderingMode: Optionally specify a symbol rendering mode to be used on platforms that support it.
    public static func image(
        forVolumeLevel level: Double?,
        useVariable: Bool = false,
        renderingMode: HUDStaticSystemImageSource.RenderingMode? = nil
    ) -> Self {
        .symbol(.image(forVolumeLevel: level, useVariable: useVariable, renderingMode: renderingMode))
    }
}

#endif
