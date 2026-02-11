//
//  ProminentHUDStyle+View Geometry.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation
import SwiftUI

// MARK: - Alert

extension ProminentHUDStyle {
    enum Geometry {
        static var alertScreenRect: NSRect? {
            try? NSScreen.alertScreen.effectiveAlertScreenRect
        }
        
        // based on Xcode 26.3's built-in HUD alerts
        static let standardImageSize: CGFloat = 110.0
        
        static let padding: CGFloat = 20.0
        
        static var maxContentWidth: CGFloat? {
            guard let alertScreenRect else { return nil }
            return alertScreenRect.width - (padding * 4)
        }
        
        static func minSize(isImagePresent: Bool, isTextPresent: Bool) -> CGFloat? {
            if isImagePresent, isTextPresent {
                standardImageSize * 1.45
            } else if isImagePresent {
                standardImageSize * 1.4
            } else {
                nil
            }
        }
    }
}

#endif
