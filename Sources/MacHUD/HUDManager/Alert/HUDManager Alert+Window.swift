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
    static var defaultScaleFactor: CGFloat { 0.9 }
    
    static func scaleFactorToShrinkWindow(scaleFactor: CGFloat) -> NSSize {
        let scaleFactor = scaleFactor.clamped(to: 0.1 ... 2.0)
        return NSSize(width: scaleFactor, height: scaleFactor)
    }
    
    static func scaleFactorToResetWindow(scaleFactor: CGFloat) -> NSSize {
        let shrinkFactor = scaleFactorToShrinkWindow(scaleFactor: scaleFactor)
        return NSSize(
            width: 1.0 / shrinkFactor.width,
            height: 1.0 / shrinkFactor.height
        )
    }
    
    /// Creates a new reusable alert window and configures it.
    @MainActor
    func windowFactory() async throws -> NSWindow {
        // Note: style mask `.hudWindow` only applies to NSPanel, not NSWindow
        let window = NSWindow(
            contentRect: NSMakeRect(0, 0, 200, 200),
            styleMask: await style.windowStyleMask(),
            backing: .buffered,
            defer: true
        )
        
        guard let contentView = window.contentView else {
            throw HUDError.internalInconsistency("Window has no content view.")
        }
        
        let reusableView = NSHostingView(rootView: BaseContentView())
        contentView.autoresizesSubviews = false
        contentView.addSubview(reusableView)
        
        // set up UI
        
        window.titleVisibility = .hidden
        window.titlebarAppearsTransparent = true
        window.level = .screenSaver
        window.hidesOnDeactivate = false
        window.ignoresMouseEvents = true
        window.isExcludedFromWindowsMenu = true
        window.allowsToolTipsWhenApplicationIsInactive = false
        window.isMovableByWindowBackground = false
        window.animationBehavior = .none
        
        window.collectionBehavior = [
            .ignoresCycle, .stationary, .canJoinAllSpaces, .fullScreenAuxiliary, .transient
        ]
        if #available(macOS 13, *) {
            window.collectionBehavior.insert(.auxiliary)
        }
        
        // newContentView.sizingOptions = [.intrinsicContentSize] // macOS 13+ only
        // reusableView.frame = contentView.bounds
        reusableView.addFrameConstraints(toParent: contentView)
        
        // style formatting
        let context = try Self.context(window: window)
        await style.setupWindow(context: context)
        
        return window
    }
    
    /// Updates the reusable window with new parameters.
    @MainActor
    func _updateWindow(
        content: Style.AlertContent
    ) async throws {
        guard let window else {
            throw HUDError.internalInconsistency("Missing HUD alert window.")
        }
        guard let reusableView = getHostingView() else {
            throw HUDError.internalInconsistency("Missing HUD alert reusable content view.")
        }
        
        let style = await style
        try autoreleasepool {
            // get screen for alert
            let alertScreen = try NSScreen.alertScreen
            let screenRect = alertScreen.effectiveAlertScreenRect
            
            // assert scale factor has been reset to default
            assert(window.contentView?.isRotatedOrScaledFromBase == false)
            
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
            style.updateWindow(context: context)
            
            // constrain to available screen area if needed
            window.setFrame(
                window.constrainFrameRect(window.frame, to: alertScreen),
                display: true
            )
        }
    }
    
    /// Shows the alert on screen, optionally animating its appearance and dismissal.
    @MainActor
    func _showWindow() async throws {
        let style = await style
        
        guard let window else {
            throw HUDError.internalInconsistency("Missing HUD alert window.")
        }
        
        // show alert
        autoreleasepool {
            window.alphaValue = 0.0
            window.orderFront(self)
        }
        
        if let transition = style.transitionIn {
            let isOpacity: Bool
            let scaleFactors: (shrink: NSSize, reset: NSSize)?
            let transitionDuration: TimeInterval
            switch transition {
            case let .opacity(duration: customDuration):
                isOpacity = true
                scaleFactors = nil
                transitionDuration = customDuration.clamped(to: 0.01 ... 5.0)
            case let .scaleAndOpacity(scaleFactor: customScaleFactor, duration: customDuration):
                isOpacity = true
                scaleFactors = (
                    shrink: Self.scaleFactorToShrinkWindow(scaleFactor: customScaleFactor ?? Self.defaultScaleFactor),
                    reset: Self.scaleFactorToResetWindow(scaleFactor: customScaleFactor ?? Self.defaultScaleFactor)
                )
                transitionDuration = customDuration.clamped(to: 0.01 ... 5.0)
            }
            
            let targetWindowFrame = window.frame
            
            // set initial state
            
            if let scaleFactors, let contentView = window.contentView {
                // contentview
                // For some reason, we need to set the original scale factor within an animation group or it will not scale on screen
                await NSAnimationContext.runAnimationGroup { context in
                    context.duration = 0.001
                    context.allowsImplicitAnimation = true
                    
                    autoreleasepool {
                        // window
                        var newFrame = targetWindowFrame
                        newFrame.origin.y += 10
                        window.animator().setFrame(newFrame, display: true, animate: false)
                        
                        assert(!contentView.isRotatedOrScaledFromBase, "Scale state is unknown. This may cause incorrect alert size on screen.")
                        let cframe = contentView.frame
                        let newContentOrigin = NSPoint(
                            x: cframe.origin.x + ((cframe.width - (cframe.width * scaleFactors.shrink.width)) / 2),
                            y: cframe.origin.y + ((cframe.height * scaleFactors.shrink.height) / 4)
                        )
                        contentView.setFrameOrigin(newContentOrigin)
                        contentView.animator().scaleUnitSquare(to: scaleFactors.shrink)
                    }
                }
            }
            
            if !isOpacity {
                autoreleasepool {
                    window.alphaValue = 1.0
                }
            }
            
            // animate alert appearing
            // NOTE: Animations will not work unless called on main thread/actor
            await NSAnimationContext.runAnimationGroup { context in
                context.duration = transitionDuration
                context.allowsImplicitAnimation = true
                
                autoreleasepool {
                    if isOpacity {
                        window.animator().alphaValue = 1.0
                    }
                    
                    if let scaleFactors, let contentView = window.contentView {
                        window.animator().setFrame(targetWindowFrame, display: true, animate: true)
                        
                        let cframe = contentView.frame
                        let newContentOrigin = NSPoint(
                            x: cframe.origin.x - ((cframe.width - (cframe.width * scaleFactors.shrink.width)) / 2),
                            y: cframe.origin.y - ((cframe.height * scaleFactors.shrink.height) / 4)
                        )
                        contentView.setFrameOrigin(newContentOrigin)
                        contentView.animator().scaleUnitSquare(to: scaleFactors.reset)
                    }
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
        let duration = style.duration.clamped(to: 0.1...)
        try? await Task.sleep(seconds: duration)
        
        // dismiss
        do {
            try await dismiss(transition: style.transitionOut)
        } catch {
            logger.debug("Error dismissing HUD alert: \(error.localizedDescription)")
        }
    }
}

#endif
