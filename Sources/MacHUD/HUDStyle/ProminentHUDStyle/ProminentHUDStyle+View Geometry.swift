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

// MARK: - Progress Bar

extension ProminentHUDStyle.Geometry {
    static let backColor: Color = .black.opacity(0.8) // TODO: make dynamic based on color scheme
    static let foreColor: Color = .white // TODO: make dynamic based on color scheme
    
    static let segmentHeight: CGFloat = 6.0 // actual measurements of macOS HUD
    static let width: CGFloat = 161.0 // actual measurements of macOS HUD
    
    static let standardSegmentCount: Int = 16
}

#endif
