//
//  HUDAlertContent.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import SwiftUI

public enum HUDAlertContent {
    case text(String)
    case image(ImageSource)
    case textAndImage(text: String, image: ImageSource)
}

extension HUDAlertContent: Equatable { }

extension HUDAlertContent: Sendable { }

// MARK: - Image

extension HUDAlertContent {
    public enum ImageSource {
        case systemName(String)
        case image(Image) // not Hashable
    }
}

extension HUDAlertContent.ImageSource: Equatable { }

extension HUDAlertContent.ImageSource: Sendable { }

#endif
