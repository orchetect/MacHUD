//
//  ProminentHUDAlertContent.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import SwiftUI

extension ProminentHUDStyle {
    public enum AlertContent: HUDAlertContent {
        case text(String)
        case image(HUDImageSource)
        case textAndImage(text: String, image: HUDImageSource)
        // TODO: add progress slider (volume level, screen brightness, etc.)
    }
}

#endif
