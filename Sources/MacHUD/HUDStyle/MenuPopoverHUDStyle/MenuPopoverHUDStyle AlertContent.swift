//
//  MenuPopoverHUDStyle AlertContent.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import SwiftUI

@available(macOS 26.0, *)
extension MenuPopoverHUDStyle {
    public enum AlertContent: HUDAlertContent {
        case text(String)
        case image(HUDImageSource)
        case textAndImage(text: String, image: HUDImageSource)
        // TODO: add progress slider (volume level, screen brightness, etc.) with image end-caps
    }
}

#endif
