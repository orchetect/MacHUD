//
//  HUDStaticSystemImageSource RenderingMode.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import SwiftUI

extension HUDStaticSystemImageSource {
    /// Backwards-compatible proxy type for SwiftUI's native `SymbolRenderingMode`.
    public enum RenderingMode {
        /// A mode that renders symbols as multiple layers, with different opacities applied to the foreground style.
        case hierarchical
        
        /// A mode that renders symbols as a single layer filled with the foreground style.
        case monochrome
        
        /// A mode that renders symbols as multiple layers with their inherit styles.
        case multicolor
        
        /// A mode that renders symbols as multiple layers, with different styles applied to the layers.
        case palette
    }
}

extension HUDStaticSystemImageSource.RenderingMode: Equatable { }

extension HUDStaticSystemImageSource.RenderingMode: Hashable { }

extension HUDStaticSystemImageSource.RenderingMode: Sendable { }

// MARK: - Properties

extension HUDStaticSystemImageSource.RenderingMode {
    /// Returns the corresponding `SymbolRenderingMode` case.
    @available(macOS 12.0, *)
    public var symbolRenderingMode: SymbolRenderingMode {
        switch self {
        case .hierarchical: .hierarchical
        case .monochrome: .monochrome
        case .multicolor: .multicolor
        case .palette: .palette
        }
    }
}

#endif
