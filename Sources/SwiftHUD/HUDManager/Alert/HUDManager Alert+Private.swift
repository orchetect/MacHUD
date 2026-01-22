//
//  HUDManager Alert+Private.swift
//  swift-hud • https://github.com/orchetect/swift-hud
//

import AppKit
import SwiftUI
internal import SwiftExtensions

extension HUDManager.Alert {
    /// Creates a new reusable alert window and configures it.
    @MainActor
    static func windowFactory() throws -> (
        window: NSWindow,
        view: NSView,
        visualEffectView: NSVisualEffectView,
        blurFilter: CIFilter?,
        contentView: NSHostingView<HUDManager.Alert.ContentView>
    ) {
        let newWindow = NSWindow(
            contentRect: NSMakeRect(0, 0, 500, 160),
            styleMask: .borderless,
            backing: .buffered,
            defer: true
        )
        
        guard let newView = newWindow.contentView else {
            throw HUDError.internalInconsistency("Window has no content view.")
        }
        
        let newContentView = NSHostingView(rootView: ContentView())
        // newContentView.sizingOptions = [.intrinsicContentSize] // macOS 13+ only
        
        newView.addSubview(newContentView)
        
        // grab screen
        let alertScreen = try alertScreen
        
        // origin is bottom left of screen. Y axis goes up, X axis goes right.
        let screenRect = try getEffectiveAlertScreenRect()
        
        // set up UI
        
        newWindow.styleMask = [.borderless] // already set at window creation, above
        newWindow.level = .screenSaver
        newWindow.hidesOnDeactivate = false
        newWindow.ignoresMouseEvents = true
        newWindow.isExcludedFromWindowsMenu = true
        newWindow.allowsToolTipsWhenApplicationIsInactive = false
        newWindow.collectionBehavior = [
            .ignoresCycle, .stationary, .canJoinAllSpaces, .fullScreenAuxiliary, .transient
        ]
        if #available(macOS 13, *) {
            newWindow.collectionBehavior.insert(.auxiliary)
        }
        
        newWindow.isOpaque = false
        newWindow.backgroundColor = .clear
        
        newContentView.translatesAutoresizingMaskIntoConstraints = false
        newView.addConstraint(.init(
            item: newContentView as Any,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: newView,
            attribute: .centerY,
            multiplier: 1,
            constant: 0
        ))
        newView.addConstraint(.init(
            item: newContentView as Any,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: newView,
            attribute: .centerX,
            multiplier: 1,
            constant: 0
        ))
        newView.addConstraint(.init(
            item: newContentView as Any,
            attribute: .width,
            relatedBy: .equal,
            toItem: newContentView,
            attribute: .width,
            multiplier: 1,
            constant: 0
        ))
        newView.addConstraint(.init(
            item: newContentView as Any,
            attribute: .height,
            relatedBy: .equal,
            toItem: newContentView,
            attribute: .height,
            multiplier: 1,
            constant: 0
        ))
        newWindow.maxSize = screenRect.size
        newWindow.contentMaxSize = screenRect.size
        
        newView.wantsLayer = true // needed to enable corner radius mask
        newView.layer?.masksToBounds = true
        newView.layer?.cornerRadius = 20
        newView.layerUsesCoreImageFilters = true // doesn't have any effect?
        newView.autoresizesSubviews = true // doesn't have any effect?
        
        // Apple's dark translucent blur effect
        newWindow.backgroundColor = NSColor.clear
        let newBlurEffectView = NSVisualEffectView()
        newView.addSubview(newBlurEffectView, positioned: .below, relativeTo: newView)
        
        newBlurEffectView.state = .active
        newBlurEffectView.blendingMode = .behindWindow
        newBlurEffectView.frame = newView.bounds // always fill the view
        newBlurEffectView.autoresizingMask = [.width, .height]
        
        // animating CIFilters needs to be added to the view’s filters array, not the layer’s content or background filters arrays.
        let blurFilter: CIFilter? = nil /* = CIFilter(
            name: "CIMotionBlur",
            parameters: [kCIInputRadiusKey: 0]
        )
        if let blurFilter {
            newView.contentFilters.append(blurFilter)
        }
        */
        
        return (window: newWindow, view: newView, visualEffectView: newBlurEffectView, blurFilter: blurFilter, contentView: newContentView)
    }
    
    /// Updates the reusable window with new parameters.
    @MainActor
    func _updateWindow(
        content: HUDManager.AlertContent,
        style: HUDStyle
    ) throws {
        guard let hudWindow else {
            throw HUDError.internalInconsistency("Missing HUD alert window.")
        }
        guard let hudView else {
            throw HUDError.internalInconsistency("Missing HUD alert view.")
        }
        guard let hudViewVisualEffectView else {
            throw HUDError.internalInconsistency("Missing HUD alert visual effect view.")
        }
        // guard let hudViewCIMotionBlur else {
        //     throw HUDError.internalInconsistency("Missing HUD alert motion blur filter.")
        // }
        guard let contentView else {
            throw HUDError.internalInconsistency("Missing HUD alert content view.")
        }
        
        // get screen for alert
        let alertScreen = try Self.alertScreen
        
        // origin is bottom left of screen. Y axis goes up, X axis goes right.
        let screenRect = try Self.getEffectiveAlertScreenRect()
        
        // set content to display
        contentView.rootView = .init(content: content, style: style)
        hudWindow.setContentSize(contentView.frame.size)
        
        // theme / formatting customization
        
        if style.isBordered {
            let borderWidth: Int = switch style.size {
            case .small: 1
            case .medium: 2
            case .large: 3
            case .extraLarge: 4
            }
            
            switch style.tint {
            case .light, .mediumLight:
                hudView.layer?.borderWidth = CGFloat(borderWidth)
                hudView.layer?.borderColor = NSColor(red: 0.15, green: 0.16, blue: 0.17, alpha: 1.00).cgColor
                
            case .dark, .ultraDark:
                hudView.layer?.borderWidth = CGFloat(borderWidth)
                hudView.layer?.borderColor = NSColor.white.cgColor
            }
        } else {
            hudView.layer?.borderWidth = 0
        }
        
        let topOrBottomOffset: CGFloat = 140.0
        let y: CGFloat = switch style.position {
        case .bottom: topOrBottomOffset
        case .center: (screenRect.size.height - contentView.frame.size.height) * 0.5
        case .top: (screenRect.size.height - contentView.frame.size.height - topOrBottomOffset)
        }
        let displayBounds = NSMakeRect(
            (screenRect.size.width - contentView.frame.size.width) * 0.5,
            y,
            contentView.frame.size.width,
            contentView.frame.size.height
        )
        
        // apply sizes
        hudWindow.setFrame(displayBounds, display: true)
        hudWindow.setFrame(
            hudWindow.constrainFrameRect(hudWindow.frame, to: alertScreen),
            display: true
        )
        
        // hudViewVisualEffectView (NSVisualEffectView)
        hudViewVisualEffectView.material = switch style.tint {
        case .light: .light
        case .mediumLight: .mediumLight
        case .dark: .dark
        case .ultraDark: .ultraDark
        }
        
        // hudViewCIMotionBlur (CIFilter)
        
        // reset blur value to default
        // hudViewCIMotionBlur.setValue(0, forKeyPath: kCIInputRadiusKey)
    }
    
    /// Shows the alert on screen, optionally animating its appearance and dismissal.
    @MainActor
    func _showWindow(
        transitionIn: HUDStyle.Transition,
        duration: TimeInterval,
        transitionOut: HUDStyle.Transition
    ) async throws {
        guard let hudWindow else {
            throw HUDError.internalInconsistency("Missing HUD alert window.")
        }
        
        // show alert
        hudWindow.alphaValue = 0
        hudWindow.orderFront(self)
        
        if let fadeInDuration: TimeInterval = switch transitionIn {
        case .default: 0.05
        case let .fade(duration: customDuration): customDuration
        case .none: nil
        } {
            // animate alert appearing
            // NOTE: Animations will not work unless called on main thread/actor
            await NSAnimationContext.runAnimationGroup { context in
                context.duration = fadeInDuration
                hudWindow.animator().alphaValue = 1
            }
        } else {
            // don't animate alert appearing
            hudWindow.alphaValue = 1
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
    
    static var alertScreen: NSScreen {
        get throws {
            // grab first screen (not main).
            // main will reference focused screen if user has "Displays have separate Spaces"
            // enabled in System Preferences -> Mission Control.
            guard let screen = NSScreen.screens.first else {
                throw HUDError.internalInconsistency("Can't get reference to main screen.")
            }
            return screen
        }
    }
    
    static func getEffectiveAlertScreenRect() throws -> NSRect {
        // grab screen
        let alertScreen = try alertScreen
        
        // determine maximum size for alert
        let screenRect = alertScreen.visibleFrame
        
        return screenRect
    }
    
    static func textOnlyAlertFontSize() -> CGFloat {
        do {
            let screen = try getEffectiveAlertScreenRect()
            return textOnlyAlertFontSize(forScreenSize: screen.size)
        } catch {
            // provide a reasonable default
            return textOnlyAlertFontSize(forScreenSize: CGSize(width: 1920, height: 1080))
        }
    }
    
    static func textOnlyAlertFontSize(forScreenSize screenSize: CGSize) -> CGFloat {
        screenSize.width / 40
    }
}
