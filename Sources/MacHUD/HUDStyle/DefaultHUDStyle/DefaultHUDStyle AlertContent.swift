//
//  DefaultHUDStyle AlertContent.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import SwiftUI

extension DefaultHUDStyle {
    /// Alert content that can adapt to the default HUD style.
    public enum AlertContent: HUDAlertContent {
        case text(String)
        case image(HUDImageSource)
        case textAndImage(text: String, image: HUDImageSource)
        // TODO: add progress slider (volume level, screen brightness, etc.) with image end-caps
    }
}

extension DefaultHUDStyle.AlertContent {
    func convertedToProminentHUDStyle() -> ProminentHUDStyle.AlertContent {
        switch self {
        case let .text(text): .text(text)
        case let .image(imageSource): .image(imageSource)
        case let .textAndImage(text, image): .imageAndText(text: text, image: image)
        }
    }
    
    @available(macOS 26.0, *)
    func convertedToMenuPopoverHUDStyle() -> MenuPopoverHUDStyle.AlertContent {
        switch self {
        case let .text(text): .text(text)
        case let .image(imageSource): .image(imageSource)
        case let .textAndImage(text, image): .textAndImage(text: text, image: image)
        }
    }
}

#endif
