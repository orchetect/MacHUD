//
//  HUDStaticSystemImageSource.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import SwiftUI

/// Static system symbol image source for use in HUD alerts.
public enum HUDStaticSystemImageSource {
    /// System symbol image with optional variable value and rendering mode.
    /// Variable value will only be applied on macOS 13.0+ and rendering mode will only be applied
    /// on macOS 11.0+.
    case systemName(String, variable: Double? = nil, renderingMode: RenderingMode? = nil)
}

extension HUDStaticSystemImageSource: Equatable { }

extension HUDStaticSystemImageSource: Hashable { }

extension HUDStaticSystemImageSource: Sendable { }

// MARK: - Helpers

extension HUDStaticSystemImageSource {
    /// Returns the image source as a SwiftUI `Image` instance.
    public var image: Image? { // TODO: refactor as non-Optional
        switch self {
        case let .systemName(systemName, variable: variable, renderingMode: renderingMode):
            guard let baseImage: Image = if #available(macOS 13.0, *) {
                Image(systemName: systemName, variableValue: variable)
            } else if #available(macOS 11.0, *) {
                Image(systemName: systemName)
            } else {
                // TODO: needs implementation on macOS 10.15
                nil
            } else {
                return nil
            }
            
            return if #available(macOS 12.0, *), let renderingMode {
                baseImage
                    .symbolRenderingMode(renderingMode.symbolRenderingMode)
            } else {
                baseImage
            }
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

extension HUDStaticSystemImageSource {
    /// Returns an appropriate system symbol image for the given audio volume level.
    ///
    /// - Parameters:
    ///   - level: Volume level in range `0.0 ... 1.0`. Passing `nil` returns an image suitable for a muted audio state.
    ///   - useVariable: When `true`, for all unmuted audio levels, use the variable fill of the 3-wave speaker symbol.
    ///   - renderingMode: Optionally specify a symbol rendering mode to be used on platforms that support it.
    public static func image(
        forVolumeLevel level: Double?,
        useVariable: Bool = false,
        renderingMode: RenderingMode? = nil
    ) -> Self {
        guard let rawLevel = level else {
            return .systemName("speaker.slash.fill", renderingMode: renderingMode)
        }
        let level = rawLevel.clamped(to: 0.0 ... 1.0)
        
        if useVariable {
            return .systemName("speaker.wave.3.fill", variable: level, renderingMode: renderingMode)
        }
        
        let systemName = switch level {
        case ...0.0: "speaker.fill"
        case 0.0 ... 0.33: "speaker.wave.1.fill"
        case 0.33 ... 0.66: "speaker.wave.2.fill"
        default /* case 0.66 ... 1.0 */: "speaker.wave.3.fill"
        }
        
        return .systemName(systemName, renderingMode: renderingMode)
    }
}

#endif
