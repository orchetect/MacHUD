//
//  MenuPopoverHUDStyle+Window.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation
import SwiftUI

@available(macOS 26.0, *)
extension MenuPopoverHUDStyle {
    public func windowStyleMask() -> NSWindow.StyleMask {
        [.fullSizeContentView]
    }
    
    static let cornerRadius: CGFloat = 25.0
    
    @MainActor
    public func setupWindow(context: HUDWindowContext) {
        // context.window.hasShadow = false // this also disables window border 🙁
        
        context.setCornerRadius(radius: Self.cornerRadius)
        context.applyLiquidGlassEffect(cornerRadius: Self.cornerRadius)
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
    static let size: CGSize = CGSize(width: 292, height: 64)
    static let screenEdgeOffset: CGFloat = 10.0
    
    @MainActor
    func windowFrame(
        contentViewSize: CGSize,
        effectiveScreenRect: CGRect,
        isFullScreen: Bool
    ) -> NSRect {
        let screenSize = effectiveScreenRect.size
        
        // debugging
        // if let item = statusItem?(),
        //    item.isVisible,
        //    let itemButton = item.button
        // {
        //     logger.debug("StatusItem: \(item)")
        //     logger.debug("StatusItem button bounds: \(itemButton.bounds)")
        //     logger.debug("StatusItem button frame: \(itemButton.frame)")
        //     logger.debug("StatusItem button superview: \(itemButton.superview)")
        //     logger.debug("StatusItem button superview frame: \(itemButton.superview?.frame)")
        //     logger.debug("StatusItem button window: \(itemButton.window)")
        //     logger.debug("StatusItem button window frame: \(itemButton.window?.frame)")
        //     logger.debug("StatusItem button window frame midX: \(itemButton.window?.frame.midX)")
        // }
        
        let x: CGFloat = if isFullScreen {
            // in full screen mode, always display at top center of screen
            (screenSize.width - contentViewSize.width) * 0.5
        } else if let item = statusItem?(),
                  item.isVisible,
                  let itemButton = item.button,
                  let windowFrame = itemButton.window?.frame
        {
            // if status item is present and visible, present as a popover under the status item in the menubar
            {
                let itemMidX = windowFrame.origin.x + (itemButton.frame.width / 2)
                let x = itemMidX - (contentViewSize.width / 2)
                return x
            }()
        } else {
            // otherwise, fallback to top right corner of screen as a default
            (screenSize.width - contentViewSize.width - Self.screenEdgeOffset)
        }
        
        return NSMakeRect(
            effectiveScreenRect.origin.x + x,
            effectiveScreenRect.origin.y + screenSize.height - contentViewSize.height - Self.screenEdgeOffset,
            contentViewSize.width,
            contentViewSize.height
        )
    }
}

#endif
