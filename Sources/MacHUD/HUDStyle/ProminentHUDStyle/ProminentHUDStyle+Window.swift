//
//  ProminentHUDStyle+Window.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation
import SwiftUI

extension ProminentHUDStyle {
    @MainActor public func setupWindow(context: HUDWindowContext) {
        context.setCornerRadius(radius: 20)
        context.applyVisualEffect()
    }
    
    @MainActor public func updateWindow(context: HUDWindowContext) {
        guard let contentView = context.window.contentView else { return }
        
        // apply style
        if isBordered {
            contentView.layer?.borderWidth = borderWidth
            contentView.layer?.borderColor = borderColor
        } else {
            contentView.layer?.borderWidth = 0.0
        }
        
        // set window size and position
        let displayBounds = windowFrame(
            contentViewSize: contentView.frame.size,
            effectiveScreenSize: context.effectiveAlertScreenRect.size
        )
        context.window.setFrame(displayBounds, display: true)
        
        // update NSVisualEffectView
        if let visualEffectView = context.visualEffectView {
            visualEffectView.material = visualEffectViewMaterial
        } else {
            assertionFailure("Can't find HUD alert window's visual effect view while attempting to update window.")
        }
    }
}

extension ProminentHUDStyle {
    var borderWidth: CGFloat {
        switch size {
        case .small: 1.0
        case .medium: 2.0
        case .large: 3.0
        case .extraLarge: 4.0
        }
    }
    
    var borderColor: CGColor {
        switch tint {
        case .light, .mediumLight:
            NSColor(red: 0.15, green: 0.16, blue: 0.17, alpha: 1.00)
                .cgColor
            
        case .dark, .ultraDark:
            NSColor.white
                .cgColor
        }
    }
    
    var visualEffectViewMaterial: NSVisualEffectView.Material {
        switch tint {
        case .light: .light
        case .mediumLight: .mediumLight
        case .dark: .dark
        case .ultraDark: .ultraDark
        }
    }
    
    static let topOrBottomScreenOffset: CGFloat = 140.0
    
    func windowFrame(contentViewSize: CGSize, effectiveScreenSize: CGSize) -> NSRect {
        let y: CGFloat = switch position {
        case .bottom: Self.topOrBottomScreenOffset
        case .center: (effectiveScreenSize.height - contentViewSize.height) * 0.5
        case .top: (effectiveScreenSize.height - contentViewSize.height - Self.topOrBottomScreenOffset)
        }
        
        let windowFrame = NSMakeRect(
            (effectiveScreenSize.width - contentViewSize.width) * 0.5,
            y,
            contentViewSize.width,
            contentViewSize.height
        )
        return windowFrame
    }
}

#endif
