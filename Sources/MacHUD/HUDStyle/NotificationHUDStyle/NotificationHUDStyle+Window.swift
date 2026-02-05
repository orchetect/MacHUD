//
//  NotificationHUDStyle+Window.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation
import SwiftUI

@available(macOS 26.0, *)
extension NotificationHUDStyle {
    @MainActor
    public func setupWindow(context: HUDWindowContext) {
        context.setCornerRadius(radius: 20)
//        context.applyLiquidGlassEffect(cornerRadius: 20)
        // context.window.alphaValue = 0.8
    }
    
    @MainActor
    public func updateWindow(context: HUDWindowContext) {
        guard let contentView = context.window.contentView else { return }
        
        // set window size and position
        
        // note that in macOS 26, this HUD shows up in the upper-right corner of the screen below the menubar.
        // however, when an app is in full-screen mode, the HUD shows up in the upper center of the screen.
        
        let displayBounds = windowFrame(
            contentViewSize: contentView.frame.size,
            effectiveScreenRect: context.effectiveAlertScreenRect,
            isFullScreen: context.isFullScreenMode
        )
        context.window.setFrame(displayBounds, display: true)
    }
    
    // These values are current as of macOS 26
    static let screenEdgeTopOffset: CGFloat = 10.0
    static let screenEdgeSideOffset: CGFloat = 50.0
    
    func windowFrame(
        contentViewSize: CGSize,
        effectiveScreenRect: CGRect,
        isFullScreen: Bool
    ) -> NSRect {
        let screenSize = effectiveScreenRect.size
        
        let x: CGFloat = if isFullScreen {
            // top center of screen
            (screenSize.width - contentViewSize.width) * 0.5
        } else {
            // top right corner of screen
            (screenSize.width - contentViewSize.width - Self.screenEdgeSideOffset)
        }
        
        return NSMakeRect(
            effectiveScreenRect.origin.x + x,
            effectiveScreenRect.origin.y + screenSize.height - contentViewSize.height - Self.screenEdgeTopOffset,
            contentViewSize.width,
            contentViewSize.height
        )
    }
}

#endif
