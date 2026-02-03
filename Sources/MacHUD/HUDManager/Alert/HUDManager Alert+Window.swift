//
//  HUDManager Alert+Window.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import AppKit
import SwiftUI
internal import SwiftExtensions

extension HUDManager.Alert {
    /// Creates a new reusable alert window and configures it.
    @MainActor
    static func windowFactory(style: AnyHUDStyle) throws -> (
        window: NSWindow,
        reusableView: NSHostingView<HUDManager.AlertBaseContentView>
    ) {
        let window = NSWindow(
            contentRect: NSMakeRect(0, 0, 200, 200),
            styleMask: [.borderless],
            backing: .buffered,
            defer: true
        )
        
        guard let contentView = window.contentView else {
            throw HUDError.internalInconsistency("Window has no content view.")
        }
        
        let reusableView = NSHostingView(rootView: HUDManager.AlertBaseContentView())
        contentView.addSubview(reusableView)
        
        // set up UI
        
        window.level = .screenSaver
        window.hidesOnDeactivate = false
        window.ignoresMouseEvents = true
        window.isExcludedFromWindowsMenu = true
        window.allowsToolTipsWhenApplicationIsInactive = false
        window.collectionBehavior = [
            .ignoresCycle, .stationary, .canJoinAllSpaces, .fullScreenAuxiliary, .transient
        ]
        if #available(macOS 13, *) {
            window.collectionBehavior.insert(.auxiliary)
        }
        
        // newContentView.sizingOptions = [.intrinsicContentSize] // macOS 13+ only
        reusableView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraint(.init(
            item: reusableView as Any,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: contentView,
            attribute: .centerY,
            multiplier: 1,
            constant: 0
        ))
        contentView.addConstraint(.init(
            item: reusableView as Any,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: contentView,
            attribute: .centerX,
            multiplier: 1,
            constant: 0
        ))
        contentView.addConstraint(.init(
            item: reusableView as Any,
            attribute: .width,
            relatedBy: .equal,
            toItem: reusableView,
            attribute: .width,
            multiplier: 1,
            constant: 0
        ))
        contentView.addConstraint(.init(
            item: reusableView as Any,
            attribute: .height,
            relatedBy: .equal,
            toItem: reusableView,
            attribute: .height,
            multiplier: 1,
            constant: 0
        ))
        
        // style formatting
        let context = try context(window: window, reusableView: reusableView)
        style.base.setupWindow(context: context)
        
        return (window: window, reusableView: reusableView)
    }
    
    /// Updates the reusable window with new parameters.
    @MainActor
    func _updateWindow(
        content: HUDAlertContent,
        style: AnyHUDStyle
    ) throws {
        guard let window else {
            throw HUDError.internalInconsistency("Missing HUD alert window.")
        }
        guard let reusableView else {
            throw HUDError.internalInconsistency("Missing HUD alert reusable content view.")
        }
        
        try autoreleasepool {
            // get screen for alert
            let alertScreen = try NSScreen.alertScreen
            let screenRect = alertScreen.effectiveAlertScreenRect
            
            // set max alert size
            window.contentMaxSize = screenRect.size
            window.maxSize = screenRect.size
            
            // set content to display
            reusableView.rootView = .init(content: content, style: style)
            // prevents window from remaining too large if previously shown at a larger content size
            window.setContentSize(.zero)
            window.setContentSize(reusableView.frame.size)
            
            // style formatting
            let context = try context()
            style.base.updateWindow(context: context)
            
            // constrain to available screen area if needed
            window.setFrame(
                window.constrainFrameRect(window.frame, to: alertScreen),
                display: true
            )
        }
    }
    
    /// Shows the alert on screen, optionally animating its appearance and dismissal.
    @MainActor
    func _showWindow(
        transitionIn: HUDTransition,
        duration: TimeInterval,
        transitionOut: HUDTransition
    ) async throws {
        guard let window else {
            throw HUDError.internalInconsistency("Missing HUD alert window.")
        }
        
        // show alert
        autoreleasepool {
            window.alphaValue = 0.0
            window.orderFront(self)
        }
        
        if let fadeInDuration: TimeInterval = switch transitionIn {
        case .default: 0.05
        case let .fade(duration: customDuration): customDuration
        case .none: nil
        } {
            // animate alert appearing
            // NOTE: Animations will not work unless called on main thread/actor
            await NSAnimationContext.runAnimationGroup { context in
                context.duration = fadeInDuration
                autoreleasepool {
                    window.animator().alphaValue = 1.0
                }
            }
        } else {
            // don't animate alert appearing
            autoreleasepool {
                window.alphaValue = 1.0
            }
        }
        
        // remain on screen for specified time period; schedule the fade out
        // prevent time values being too small as failsafe
        let duration = duration.clamped(to: 0.1...)
        try? await Task.sleep(seconds: duration)
        
        // dismiss
        do {
            try await dismiss(transition: transitionOut)
        } catch {
            logger.debug("Error dismissing HUD alert: \(error.localizedDescription)")
        }
    }
}

#endif
