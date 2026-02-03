//
//  HUDWindowContext+Methods.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import AppKit
import Foundation
import SwiftUI

extension HUDWindowContext {
    /// Sets a corner radius to the window.
    public func setCornerRadius(radius: CGFloat) {
        window.contentView?.wantsLayer = true // needed to enable corner radius mask
        window.contentView?.layer?.masksToBounds = true
        window.contentView?.layer?.cornerRadius = radius
    }
    
    /// Applies a slightly translucent visual effect to the window.
    public func applyVisualEffect() {
        guard visualEffectView == nil else { return } // don't apply more than once
        guard let contentView = window.contentView else { return }
        
        // window.isOpaque = false // TODO: ?
        window.backgroundColor = .clear
        
        let newEffectView = NSVisualEffectView()
        contentView.addSubview(newEffectView, positioned: .below, relativeTo: contentView)
        
        newEffectView.state = .active
        newEffectView.blendingMode = .behindWindow
        newEffectView.frame = contentView.bounds // always fill the view
        newEffectView.autoresizingMask = [.width, .height]
    }
    
    /// If ``applyVisualEffect()`` was called to apply an effect to the window, this property will return
    /// a reference to the visual effect view.
    public var visualEffectView: NSVisualEffectView? {
        for subview in window.contentView?.subviews ?? [] {
            if let typedSubview = subview as? NSVisualEffectView {
                return typedSubview
            }
        }
        return nil
    }
    
    /// Returns the effective screen area available to safely display the HUD alert window.
    public var effectiveAlertScreenRect: NSRect {
        screen.visibleFrame
    }
}

#endif
