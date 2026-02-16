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
        /// Text-only alert.
        case text(String)
        
        /// Image-only alert.
        case image(HUDImageSource)
        
        /// Image and text alert.
        case imageAndText(image: HUDImageSource, text: String)
        
        /// Image or text alert depending on platform, along with a progress bar.
        case imageOrTextAndProgress(
            prominentImage: HUDImageSource,
            text: String,
            value: HUDSteppedProgressValue,
            menuPopoverProgressImages: HUDProgressImageSource? = nil
        )
    }
}

// MARK: - Helpers

extension DefaultHUDStyle.AlertContent {
    func convertedToProminentHUDStyle() -> ProminentHUDStyle.AlertContent {
        switch self {
        case let .text(text):
            .text(text)
        case let .image(imageSource):
            .image(imageSource)
        case let .imageAndText(image: image, text: text):
            .imageAndText(image: image, text: text)
        case let .imageOrTextAndProgress(prominentImage: image, text: _, value: value, menuPopoverProgressImages: _):
            .imageAndProgress(image: image, value: value)
        }
    }

    @available(macOS 26.0, *)
    func convertedToMenuPopoverHUDStyle() -> MenuPopoverHUDStyle.AlertContent {
        switch self {
        case let .text(text):
            .text(text)
        case let .image(imageSource):
            .image(imageSource)
        case let .imageAndText(image: image, text: text):
            .imageAndText(image: image, text: text)
        case let .imageOrTextAndProgress(prominentImage: _, text: text, value: value, menuPopoverProgressImages: images):
            .textAndProgress(
                text: text,
                value: value,
                images: images
            )
        }
    }
}

#endif
