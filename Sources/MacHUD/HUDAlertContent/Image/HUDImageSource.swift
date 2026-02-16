//
//  HUDImageSource.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import SwiftUI

/// Type-erased box for a HUD alert image source.
public enum HUDImageSource {
    case `static`(HUDStaticImageSource)
    case animated(HUDAnimatedImageSource)
}

extension HUDImageSource: Equatable { }

extension HUDImageSource: Sendable { }

// MARK: - Properties

extension HUDImageSource {
    /// Converts the animated image source to an ``HUDStaticImageSource`` instance using
    /// the effective image that represents the target image source (lossy if the
    /// instance is an animated image source).
    public var staticImageSource: HUDStaticImageSource {
        switch self {
        case let .static(imageSource):
            imageSource
        case let .animated(imageSource):
            imageSource.targetImageSource
        }
    }
    
    @MainActor @ViewBuilder
    public var view: (some View)? {
        switch self {
        case let .static(imageSource):
            imageSource.scalableImage
        case let .animated(imageSource):
            imageSource.view
        }
    }
}

#endif
