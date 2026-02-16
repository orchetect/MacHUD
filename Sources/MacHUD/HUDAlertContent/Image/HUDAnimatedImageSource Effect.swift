//
//  HUDAnimatedImageSource Effect.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import SwiftUI

extension HUDAnimatedImageSource {
    /// Backwards-compatible proxy type for SwiftUI's native `SymbolEffect`.
    public enum Effect {
        // /// An animation that makes the layers of a symbol-based image appear separately or as a whole.
        // /// (macOS 14+)
        // case appear
        
        /// An animation that applies a transitory scaling effect, or bounce, to the layers in a symbol-based image separately or as a whole.
        /// (macOS 15+)
        case bounce
        
        /// An animation that applies a slow transitory scaling effect to the layers in a symbol-based image separately or as a whole.
        /// (macOS 15+)
        case breathe
        
        // /// A symbol effect that applies the DrawOn animation to symbol images.
        // /// (macOS 26+)
        // case drawOn
        
        /// An animation that fades the opacity of some or all layers in a symbol-based image.
        /// (macOS 14+)
        case pulse
        
        /// An animation that rotates a symbol-based image separately or as a whole.
        /// (macOS 15+)
        case rotate
        
        // /// An animation that scales the layers in a symbol-based image separately or as a whole.
        // /// (macOS 14+)
        // case scale
        
        /// An animation that replaces the opacity of variable layers in a symbol-based image in a repeatable sequence.
        /// (macOS 14+)
        case variableColor
        
        /// An animation that wiggles a symbol-based image separately or as a whole.
        /// (macOS 15+)
        case wiggle
        
        // note: `automatic`, `disappear`, `drawOff` and `replace` aren't relevant, so are omitted here
    }
}

extension HUDAnimatedImageSource.Effect: Equatable { }

extension HUDAnimatedImageSource.Effect: Hashable { }

extension HUDAnimatedImageSource.Effect: Sendable { }

// MARK: - Helpers

extension View {
    /// Conditionally applies a symbol effect if the effect is supported on the current platform.
    /// If the effect is not supported, the view is returned unchanged.
    @ViewBuilder
    func applySymbolEffectIfPossible(_ effect: HUDAnimatedImageSource.Effect, speedMultiplier: Double? = nil) -> some View {
        switch effect {
        // case .appear:
        //     if #available(macOS 14.0, *) { symbolEffect(.appear, options: .nonRepeating.speed(speedMultiplier ?? 1.0)) } else { self }
        case .bounce:
            if #available(macOS 15.0, *) { symbolEffect(.bounce, options: .nonRepeating.speed(speedMultiplier ?? 1.0)) } else { self }
        case .breathe:
            if #available(macOS 15.0, *) { symbolEffect(.breathe, options: .nonRepeating.speed(speedMultiplier ?? 1.0)) } else { self }
        // case .drawOn:
        //     if #available(macOS 26.0, *) { symbolEffect(.drawOn, options: .nonRepeating.speed(speedMultiplier ?? 1.0)) } else { self }
        case .pulse:
            if #available(macOS 14.0, *) { symbolEffect(.pulse, options: .nonRepeating.speed(speedMultiplier ?? 1.0)) } else { self }
        case .rotate:
            if #available(macOS 15.0, *) { symbolEffect(.rotate, options: .nonRepeating.speed(speedMultiplier ?? 1.0)) } else { self }
        // case .scale:
        //     if #available(macOS 14.0, *) { symbolEffect(.scale, options: .nonRepeating.speed(speedMultiplier ?? 1.0)) } else { self }
        case .variableColor:
            if #available(macOS 14.0, *) { symbolEffect(.variableColor, options: .nonRepeating.speed(speedMultiplier ?? 1.0)) } else { self }
        case .wiggle:
            if #available(macOS 15.0, *) { symbolEffect(.wiggle, options: .nonRepeating.speed(speedMultiplier ?? 1.0)) } else { self }
        }
    }
}

#endif
