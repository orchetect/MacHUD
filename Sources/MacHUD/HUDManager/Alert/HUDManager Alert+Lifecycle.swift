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
            try await _updateWindow(content: content)
            try await _showWindow()
        } catch {
            isInUse = false
            throw error
        }
    }
    
    /// Triggers alert dismissal, animating out, and disposing of its resources.
    func dismiss(transition: HUDTransition = .default) async throws {
        guard let window = await window else {
            throw HUDError.internalInconsistency("Missing HUD alert window.")
        }
        
        let fadeTime: TimeInterval
        switch transition {
        case .default:
            fadeTime = 0.2
        case let .opacity(duration: customFadeTime):
            fadeTime = customFadeTime.clamped(to: 0.01 ... 5.0)
        case .none:
            // immediately hide window
            await _orderOutWindowAndZeroOutAlpha()
            await _resetInUse()
            return
        }
        
        _ = await Task { @MainActor in
            // begin async animation event
            await NSAnimationContext.runAnimationGroup { context in
                context.duration = fadeTime
                context.allowsImplicitAnimation = true // doesn't affect things?
                
                autoreleasepool {
                    window.animator().alphaValue = 0
                    
                    // CIMotionBlur does not animate here - have to discover a way to animate CIFilter properties.
                    // contentView.animator().contentFilters.first?.setValue(1.5, forKey: kCIInputRadiusKey)
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
            window?.orderOut(self)
            window?.alphaValue = 0
        }
    }
}

#endif
