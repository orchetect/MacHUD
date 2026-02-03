//
//  HUDManager Alert+Methods.swift
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
    func show(content: HUDManager.AlertContent, style: HUDStyle) async throws {
        if isInUse {
            // do a basic reset of the window if it's currently in use
            await Task { @MainActor in
                _orderOutWindowAndZeroOutAlpha()
                // this may not be necessary or may not do anything useful;
                // the assumption is that it cancels any already in-progress animation but it hasn't been
                // confirmed that it actually does that yet
                await NSAnimationContext.runAnimationGroup { context in
                    context.duration = 0.0
                }
            }.value
        }
        
        isInUse = true
        
        do {
            try await _updateWindow(
                content: content,
                style: style
            )
            
            try await _showWindow(
                transitionIn: style.transitionIn,
                duration: style.duration,
                transitionOut: style.transitionOut
            )
        } catch {
            isInUse = false
            throw error
        }
    }
    
    /// Triggers alert dismissal, animating out, and disposing of its resources.
    func dismiss(transition: HUDStyle.Transition = .default) async throws {
        guard let hudWindow = await hudWindow else {
            throw HUDError.internalInconsistency("Missing HUD alert window.")
        }
        guard let hudView = await hudView else {
            throw HUDError.internalInconsistency("Missing HUD alert view.")
        }
        
        let fadeTime: TimeInterval
        switch transition {
        case .none:
            // immediately hide window
            await _orderOutWindowAndZeroOutAlpha()
            await _resetInUse()
            return
            
        case .default:
            fadeTime = 0.2
            
        case let .fade(duration: customFadeTime):
            fadeTime = customFadeTime.clamped(to: 0.01 ... 5.0)
        }
        
        _ = await Task { @MainActor in
            // begin async animation event
            await NSAnimationContext.runAnimationGroup { context in
                context.duration = fadeTime
                context.allowsImplicitAnimation = true // doesn't affect things?
                
                autoreleasepool {
                    hudWindow.animator().alphaValue = 0
                    
                    // CIMotionBlur does not animate here - have to discover a way to animate CIFilter properties.
                    hudView.animator().contentFilters.first?.setValue(1.5, forKey: kCIInputRadiusKey)
                }
            }
            self._orderOutWindowAndZeroOutAlpha()
            await self._resetInUse()
        }.value
    }
    
    @HUDManager
    func _resetInUse() {
        isInUse = false
    }
    
    @MainActor
    func _orderOutWindowAndZeroOutAlpha() {
        autoreleasepool {
            hudWindow?.orderOut(self)
            hudWindow?.alphaValue = 0
        }
    }
}

#endif
