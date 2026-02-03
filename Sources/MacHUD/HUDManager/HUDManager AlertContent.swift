//
//  HUDManager AlertContent.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import SwiftUI

extension HUDManager {
    public enum AlertContent {
        case text(String)
        case image(ImageSource)
        case textAndImage(text: String, image: ImageSource)
    }
}

extension HUDManager.AlertContent: Equatable { }

extension HUDManager.AlertContent: Sendable { }

// MARK: - Image

extension HUDManager.AlertContent {
    public enum ImageSource {
        case systemName(String)
        case image(Image) // not Hashable
    }
}

extension HUDManager.AlertContent.ImageSource: Equatable { }

extension HUDManager.AlertContent.ImageSource: Sendable { }

#endif
