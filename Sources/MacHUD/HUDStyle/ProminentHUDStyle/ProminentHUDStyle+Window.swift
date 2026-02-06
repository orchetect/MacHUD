//
//  ProminentHUDStyle+Window.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation
import SwiftUI

extension ProminentHUDStyle {
    public func windowStyleMask() -> NSWindow.StyleMask {
        [.borderless]
    }
    
    @MainActor
    public func setupWindow(context: HUDWindowContext) {
        context.window.hasShadow = false
        context.setCornerRadius(radius: 20)
        context.applyVisualEffect()
    }
    
    @MainActor
    public func updateWindow(context: HUDWindowContext) {
        guard let contentView = context.window.contentView else { return }
        
        // set window size and position
        let displayBounds = windowFrame(
            contentViewSize: contentView.frame.size,
            effectiveScreenSize: context.effectiveAlertScreenRect.size
        )
        context.window.setFrame(displayBounds, display: true)
    }
}

extension ProminentHUDStyle {
    // TODO: Vestigial; removed `isBordered` property. Can delete.
    func borderColor(colorScheme: ColorScheme) -> CGColor {
        switch colorScheme {
        case .light:
            return NSColor(red: 0.15, green: 0.16, blue: 0.17, alpha: 1.00)
                .cgColor
            
        case .dark:
            return NSColor.white
                .cgColor
        @unknown default:
            assertionFailure("Unhandled color scheme: \(colorScheme).")
            return borderColor(colorScheme: .light)
        }
    }
    
    static let topOrBottomScreenEdgeOffset: CGFloat = 140.0
    
    func windowFrame(contentViewSize: CGSize, effectiveScreenSize: CGSize) -> NSRect {
        let y: CGFloat = switch position {
        case .bottom: Self.topOrBottomScreenEdgeOffset
        case .center: (effectiveScreenSize.height - contentViewSize.height) * 0.5
        case .top: (effectiveScreenSize.height - contentViewSize.height - Self.topOrBottomScreenEdgeOffset)
        }
        
        return NSMakeRect(
            (effectiveScreenSize.width - contentViewSize.width) * 0.5,
            y,
            contentViewSize.width,
            contentViewSize.height
        )
    }
}

#endif
