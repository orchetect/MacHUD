//
//  HUDManager Alert+Lifecycle.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import AppKit
internal import SwiftExtensions

// MARK: - Methods

extension HUDManager.Alert {
    /// Creates the alert window and shows it on screen.
    @HUDManager
    func show(content: Style.AlertContent, style: Style) async throws {
        if isInUse {
            // do a basic reset of the window if it's currently in use
            await Task { @MainActor in
                orderOutWindowAndZeroOutAlpha()
                // this may not be necessary or may not do anything useful;
                // the assumption is that it cancels any already in-progress animation but it hasn't been
                // confirmed that it actually does that yet
                await NSAnimationContext.runAnimationGroup { context in
                    context.duration = 0.0
                }
            }.value
        }
        
        isInUse = true
        
        self.style = style
        
        do {
            try await updateWindow(content: content)
            try await showWindow()
        } catch {
            isInUse = false
            throw error
        }
    }
    
    /// Triggers alert dismissal, animating out, and disposing of its resources.
    @MainActor
    func dismiss(transition: HUDTransition?) async throws {
        guard let window = await window else {
            throw HUDError.internalInconsistency("Missing HUD alert window.")
        }
        
        if let transition {
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
            
            // animate alert dismissing
            // NOTE: Animations will not work unless called on main thread/actor
            await NSAnimationContext.runAnimationGroup { context in
                context.duration = transitionDuration
                context.allowsImplicitAnimation = true
                
                autoreleasepool {
                    if isOpacity {
                        window.animator().alphaValue = 0
                    }
                    if let scaleFactors, let contentView = window.contentView {
                        let wframe = window.frame
                        var newFrame = wframe
                        newFrame.origin.y += 10
                        window.animator().setFrame(newFrame, display: true, animate: true)
                        
                        assert(!contentView.isRotatedOrScaledFromBase, "Scale state is unknown. This may cause incorrect alert size on screen.")
                        let cframe = contentView.frame
                        let newContentOrigin = NSPoint(
                            x: cframe.origin.x + ((cframe.width - (cframe.width * scaleFactors.shrink.width)) / 2),
                            y: cframe.origin.y + ((cframe.height * scaleFactors.shrink.height) / 4)
                        )
                        contentView.setFrameOrigin(newContentOrigin)
                        contentView.animator().scaleUnitSquare(to: scaleFactors.shrink)
                    }
                    // CIMotionBlur does not animate here - have to discover a way to animate CIFilter properties.
                    // contentView.animator().contentFilters.first?.setValue(1.5, forKey: kCIInputRadiusKey)
                }
            }
            
            // reset scaling
            if let scaleFactors, let contentView = window.contentView, contentView.isRotatedOrScaledFromBase {
                await NSAnimationContext.runAnimationGroup { context in
                    context.duration = 0.001
                    context.allowsImplicitAnimation = true
                    
                    autoreleasepool {
                        contentView.setFrameOrigin(.zero)
                        contentView.animator().scaleUnitSquare(to: scaleFactors.reset)
                    }
                }
            }
        }
        
        self.orderOutWindowAndZeroOutAlpha()
        await self.resetInUse()
    }
    
    @HUDManager
    func resetInUse() {
        isInUse = false
    }
    
    @MainActor
    func orderOutWindowAndZeroOutAlpha() {
        autoreleasepool {
            window?.orderOut(self)
            window?.alphaValue = 0
        }
    }
}

#endif
