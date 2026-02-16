//
//  HUDAnimatedImageSource.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import SwiftUI

/// Image source for use in HUD alerts.
public enum HUDAnimatedImageSource {
    /// On supported platforms, apply an animated symbol effect to a symbol image.
    /// If the platform does not support symbol effects, the symbol will be shown without using the effect.
    case image(
        HUDStaticSystemImageSource,
        effect: Effect,
        speedMultiplier: Double? = nil
    )

    /// On supported platforms, apply a transition animation replacing one symbol image with another.
    /// If the platform does not support symbol effects, only the target symbol will be shown without using a transition.
    /// Magic replace is only available on macOS 15+.
    case imageReplacement(
        initial: HUDStaticSystemImageSource,
        target: HUDStaticSystemImageSource,
        magicReplace: Bool = true,
        speedMultiplier: Double? = nil
    )
}

extension HUDAnimatedImageSource: Equatable { }

extension HUDAnimatedImageSource: Hashable { }

extension HUDAnimatedImageSource: Sendable { }

// MARK: - Properties

extension HUDAnimatedImageSource {
    /// Converts the animated image source to a ``HUDStaticImageSource`` instance using
    /// the target image source (lossy).
    public var targetImageSource: HUDStaticImageSource {
        .symbol(targetSystemImageSource)
    }
    
    /// Converts the animated image source to a ``HUDStaticSystemImageSource`` instance using
    /// the target image source (lossy).
    public var targetSystemImageSource: HUDStaticSystemImageSource {
        switch self {
        case let .image(
            imageSource,
            effect: _,
            speedMultiplier: _
        ):
            imageSource
            
        case let .imageReplacement(
            initial: _,
            target: targetImageSource,
            magicReplace: _,
            speedMultiplier: _
        ):
            targetImageSource
        }
    }
}

// MARK: - View Builder

extension HUDAnimatedImageSource {
    /// Returns the composed view.
    @MainActor @ViewBuilder
    public var view: (some View)? {
        switch self {
        case let .image(
            imageSource,
            effect: effect,
            speedMultiplier: speedMultiplier
        ):
            imageSource.scalableImage?
                .applySymbolEffectIfPossible(effect, speedMultiplier: speedMultiplier)
            
        case let .imageReplacement(
            initial: initialImageSource,
            target: targetImageSource,
            magicReplace: magicReplace,
            speedMultiplier: speedMultiplier
        ):
            ImageReplacementView(
                initialImageSource: initialImageSource,
                targetImageSource: targetImageSource,
                magicReplace: magicReplace,
                speedMultiplier: speedMultiplier
            )
        }
    }
    
    struct ImageReplacementView: View {
        let initialImageSource: HUDStaticSystemImageSource
        let targetImageSource: HUDStaticSystemImageSource
        let magicReplace: Bool
        let speedMultiplier: Double?
        
        @State private var isTransitioned: Bool = false
        
        var body: some View {
            conditionalImage
                .onAppear { Task { isTransitioned = true } }
        }
        
        @ViewBuilder
        private var conditionalImage: (some View)? {
            if magicReplace, #available(macOS 15.0, *) {
                image?
                    .contentTransition(.symbolEffect(.replace.magic(fallback: .replace), options: options))
            } else if #available(macOS 14.0, *) {
                image?
                    .contentTransition(.symbolEffect(.replace, options: options))
            } else {
                image
            }
        }
        
        private var image: (some View)? {
            if isTransitioned {
                targetImageSource.scalableImage
            } else {
                initialImageSource.scalableImage
            }
        }
        
        @available(macOS 14.0, *)
        private var options: SymbolEffectOptions {
            .nonRepeating.speed(speedMultiplier ?? 1.0)
        }
    }
}

#if DEBUG
@available(macOS 12.0, *)
#Preview("Single Image") {
    VStack(spacing: 40) {
        HUDAnimatedImageSource.image(
            .systemName("speaker.wave.3.fill", variable: 0.5, renderingMode: .hierarchical),
            effect: .bounce,
            speedMultiplier: nil
        )
        .view?
        .frame(width: 96, height: 96)
        
        HUDAnimatedImageSource.image(
            .systemName("speaker.wave.3.fill", variable: 0.5, renderingMode: .hierarchical),
            effect: .breathe,
            speedMultiplier: 2.0
        )
        .view?
        .frame(width: 96, height: 96)
        
        HUDAnimatedImageSource.image(
            .systemName("speaker.wave.3.fill", variable: 0.5, renderingMode: .hierarchical),
            effect: .pulse,
            speedMultiplier: 2.0
        )
        .view?
        .frame(width: 96, height: 96)
        
        HUDAnimatedImageSource.image(
            .systemName("speaker.wave.3.fill", variable: 0.5, renderingMode: .hierarchical),
            effect: .rotate,
            speedMultiplier: 2.0
        )
        .view?
        .frame(width: 96, height: 96)
        
        HUDAnimatedImageSource.image(
            .systemName("speaker.wave.3.fill", variable: 0.5, renderingMode: .hierarchical),
            effect: .variableColor,
            speedMultiplier: 2.0
        )
        .view?
        .frame(width: 96, height: 96)
        
        HUDAnimatedImageSource.image(
            .systemName("speaker.wave.3.fill", variable: 0.5, renderingMode: .hierarchical),
            effect: .wiggle,
            speedMultiplier: nil
        )
        .view?
        .frame(width: 96, height: 96)
    }
    .padding(40)
}

@available(macOS 12.0, *)
#Preview("Image Transition") {
    VStack(spacing: 40) {
        HUDAnimatedImageSource.imageReplacement(
            initial: .systemName("speaker.slash.fill", variable: 0.5, renderingMode: .hierarchical),
            target: .systemName("speaker.wave.3.fill", variable: 0.5, renderingMode: .hierarchical),
            magicReplace: false,
            speedMultiplier: 0.5
        )
        .view?
        .frame(width: 96, height: 96)
        
        HUDAnimatedImageSource.imageReplacement(
            initial: .systemName("speaker.wave.2.fill", renderingMode: .hierarchical),
            target: .systemName("speaker.wave.3.fill", renderingMode: .hierarchical),
            magicReplace: false,
            speedMultiplier: 0.5
        )
        .view?
        .frame(width: 96, height: 96)
    }
    .padding(40)
}

#endif

#endif
