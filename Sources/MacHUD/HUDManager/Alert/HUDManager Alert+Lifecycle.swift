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
    /// Returns true if the alert is inactive or if the alert is visibly presented on-screen
    /// but can be reused to display the new content.
    @HUDManager
    func isReusable(for content: Style.AlertContent, reserveIfReusable: Bool = true) -> Bool {
        switch phase {
        case .inactive:
            // content is irrelevant, if alert is inactive, it can used for any content
            return true
            
        case .preparingWindow,
             .transitioningIn,
             .staticallyDisplayed:
            // TODO: not performing any content comparison, but could if needed
            // ultimately it would be ideal to perform a comparison of the currently displayed
            // alert's content and the new content to be displayed.
            // if the content is similar enough, reuse of the on-screen alert would be allowed.
            // ostensibly, it would require an additional `HUDAlertContent` protocol requirement
            // to implement a method such as `isLayoutCompatible(with other: Self)`.
            _ = content
            
            if reserveIfReusable {
                cancelDisplayTimer()
            }
            
            return true
            
        case .transitioningOut:
            // there is no viable way to stop a window that is in the process of transitioning out
            return false
        }
    }
    
    /// Creates the alert window and shows it on screen.
    @HUDManager
    func show(content: Style.AlertContent, style: Style) async throws {
        do {
            switch phase {
            case .inactive:
                self.style = style
                phase = .preparingWindow
                try await updateWindow(content: content)
                try await showWindow(transition: style.transitionIn)
                
            case .preparingWindow, .transitioningIn:
                cancelDisplayTimer()
                await wait(for: .staticallyDisplayed)
                self.style = style
                try await updateWindow(content: content)
                try await showWindow(transition: style.transitionIn)
                
            case .staticallyDisplayed:
                cancelDisplayTimer()
                self.style = style
                try await updateWindow(content: content)
                try await showWindow(transition: style.transitionIn)
                
            case .transitioningOut:
                assertionFailure("Alert reuse attempted while alert is transitioning out. This shouldn't happen.")
                return
            }
        } catch {
            phase = .inactive
            throw error
        }
    }
    
    /// Triggers alert dismissal, animating out, and disposing of its resources.
    @MainActor
    func dismiss(transition: HUDTransition?) async throws {
        guard let window else {
            throw HUDError.internalInconsistency("Missing HUD alert window.")
        }
        
        if let transition {
            await setPhase(.transitioningOut)
            
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
        await self.setPhase(.inactive)
    }
    
    @HUDManager
    func setPhase(_ phase: HUDManager.AlertPhase) {
        self.phase = phase
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
