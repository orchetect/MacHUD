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
        window.isOpaque = false
        window.backgroundColor = .clear
        window.contentView?.wantsLayer = true // needed to enable corner radius mask
        
        assert(window.contentView?.layer != nil)
        window.contentView?.layer?.cornerRadius = radius
        window.contentView?.layer?.masksToBounds = true
        window.contentView?.layer?.allowsEdgeAntialiasing = true
    }
}

extension HUDWindowContext {
    /// Applies a slightly translucent visual effect to the window.
    public func applyVisualEffect(material: NSVisualEffectView.Material = .hudWindow) {
        guard visualEffectView == nil else { return } // don't apply more than once
        guard let contentView = window.contentView else { return }
        
        window.isOpaque = false
        window.backgroundColor = .clear
        
        let newEffectView = NSVisualEffectView()
        contentView.addSubview(newEffectView, positioned: .below, relativeTo: contentView)
        newEffectView.addFrameConstraints(toParent: contentView)
        
        newEffectView.state = .active
        newEffectView.blendingMode = .behindWindow
        newEffectView.material = material
    }
    
    /// If ``applyVisualEffect(material:)`` was called to apply an effect to the window, this
    /// property will return a reference to the visual effect view.
    public var visualEffectView: NSVisualEffectView? {
        for subview in window.contentView?.subviews ?? [] {
            if let typedSubview = subview as? NSVisualEffectView {
                return typedSubview
            }
        }
        return nil
    }
}

extension HUDWindowContext {
    @available(macOS 26.0, *)
    struct GlassView: View {
        let cornerRadius: CGFloat
        
        var body: some View {
            RoundedRectangle(cornerSize: CGSize(width: cornerRadius, height: cornerRadius), style: .continuous)
                .fill(.clear)
                .glassEffect(.clear, in: .rect(cornerRadius: cornerRadius, style: .continuous))
                .background(.white.opacity(0.05))
        }
    }
    
    /// Applies liquid glass visual effect to the window.
    @available(macOS 26.0, *)
    public func applyLiquidGlassEffect(cornerRadius: CGFloat) {
        guard let contentView = window.contentView else { return }
        
        window.isOpaque = false
        window.backgroundColor = .clear
        
        let newEffectView = NSHostingView(rootView: GlassView(cornerRadius: cornerRadius))
        contentView.addSubview(newEffectView, positioned: .below, relativeTo: contentView)
        newEffectView.addFrameConstraints(toParent: contentView)
    }
    
    /// If ``applyLiquidGlassEffect(cornerRadius:)`` was called to apply an effect to the window, this
    /// property will return a reference to the visual effect view.
    @available(macOS 26.0, *)
    public var liquidGlassEffectView: NSGlassEffectView? {
        for subview in window.contentView?.subviews ?? [] {
            if let typedSubview = subview as? NSGlassEffectView {
                return typedSubview
            }
        }
        return nil
    }
}

extension HUDWindowContext {
    /// Returns the effective screen area available to safely display the HUD alert window.
    public var effectiveAlertScreenRect: NSRect {
        screen.visibleFrame
    }
}

#endif
