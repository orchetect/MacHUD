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
        case text(String, subtitle: String? = nil)
        
        /// Image-only alert.
        case image(HUDImageSource)
        
        /// Image and text alert.
        case imageAndText(image: HUDImageSource, title: String, subtitle: String? = nil)
        
        /// Image or text alert depending on platform, along with a progress bar.
        case imageOrTextAndProgress(
            prominentImage: HUDImageSource,
            title: String,
            subtitle: String? = nil,
            progressValue: HUDSteppedProgressValue,
            menuPopoverProgressImages: HUDProgressImageSource? = nil
        )
        
        /// Image, text, and progress bar alert.
        case imageAndTextAndProgress(
            image: HUDImageSource,
            title: String,
            subtitle: String? = nil,
            progressValue: HUDSteppedProgressValue,
            menuPopoverProgressImages: HUDProgressImageSource? = nil
        )
    }
}

// MARK: - Helpers

extension DefaultHUDStyle.AlertContent {
    /// Converts the default HUD style alert content to prominent HUD style alert content.
    public func convertedToProminentHUDStyle() -> ProminentHUDStyle.AlertContent {
        switch self {
        case let .text(text, subtitle: subtitle):
            .text(text, subtitle: subtitle)
            
        case let .image(imageSource):
            .image(imageSource)
            
        case let .imageAndText(image: image, title: title, subtitle: subtitle):
            .imageAndText(image: image, title: title, subtitle: subtitle)
            
        case let .imageOrTextAndProgress(
            prominentImage: image,
            title: _,
            subtitle: _,
            progressValue: progressValue,
            menuPopoverProgressImages: _
        ):
            .imageAndProgress(image: image, progressValue: progressValue)
            
        case let .imageAndTextAndProgress(
            image: image,
            title: title,
            subtitle: subtitle,
            progressValue: progressValue,
            menuPopoverProgressImages: _
        ):
            .imageAndTextAndProgress(image: image, title: title, subtitle: subtitle, progressValue: progressValue)
        }
    }

    /// Converts the default HUD style alert content to menu popover HUD style alert content.
    @available(macOS 26.0, *)
    public func convertedToMenuPopoverHUDStyle() -> MenuPopoverHUDStyle.AlertContent {
        switch self {
        case let .text(title, subtitle: subtitle):
            .text(title, subtitle: subtitle)
            
        case let .image(imageSource):
            .image(imageSource)
            
        case let .imageAndText(image: image, title: title, subtitle: subtitle):
            .imageAndText(image: image, title: title, subtitle: subtitle)
            
        case let .imageOrTextAndProgress(
            prominentImage: _,
            title: title,
            subtitle: subtitle,
            progressValue: progressValue,
            menuPopoverProgressImages: progressImages
        ):
            .textAndProgress(
                title: title,
                subtitle: subtitle,
                progressValue: progressValue,
                progressImages: progressImages
            )
            
        case let .imageAndTextAndProgress(
            image: image,
            title: title,
            subtitle: subtitle,
            progressValue: progressValue,
            menuPopoverProgressImages: progressImages
        ):
            .imageAndTextAndProgress(
                image: image,
                title: title,
                subtitle: subtitle,
                progressValue: progressValue,
                progressImages: progressImages
            )
        }
    }
}

#endif
