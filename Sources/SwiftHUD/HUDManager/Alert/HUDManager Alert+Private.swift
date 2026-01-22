//
//  HUDManager Alert+Private.swift
//  swift-hud • https://github.com/orchetect/swift-hud
//

import AppKit
internal import SwiftExtensions

extension HUDManager.Alert {
    /// Creates a new reusable alert window and configures it.
    @MainActor
    static func windowFactory() throws -> (
        window: NSWindow,
        view: NSView,
        visualEffectView: NSVisualEffectView,
        blurFilter: CIFilter?,
        textField: NSTextField
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
        
        let newTextField = NSTextField()
        newView.addSubview(newTextField)
        
        // grab first screen
        // (not .main) because .main will reference focused screen if user has "Displays have separate Spaces" enabled in System Preferences -> Mission Control
        guard let nsScreen = NSScreen.main else {
            throw HUDError.internalInconsistency(
                "Can't get reference to main screen."
            )
        }
        
        // determine maximum size for alert
        let screenMainFrame = nsScreen.visibleFrame
        
        // origin is bottom left of screen. Y axis goes up, X axis goes right.
        let screenRect = NSRect(
            x:      screenMainFrame.origin.x + 50, // to right
            y:      screenMainFrame.origin.y + 50, // up
            width:  screenMainFrame.width   - 100,
            height: screenMainFrame.height  - 100
        )
        
        // set up UI
        
        newWindow.styleMask = [.borderless] // already set at window creation, above
        newWindow.level = .screenSaver
        // hudWindow.canBecomeKey = false // read-only
        // hudWindow.canBecomeMain = false // read-only
        newWindow.hidesOnDeactivate = false
        
        newWindow.ignoresMouseEvents = true
        newWindow.isExcludedFromWindowsMenu = true
        newWindow.allowsToolTipsWhenApplicationIsInactive = false
        // excludes from Exposé
        newWindow.collectionBehavior = [
            .ignoresCycle, .stationary, .canJoinAllSpaces,
            .fullScreenAuxiliary, .transient
        ]
        
        newWindow.isOpaque = false
        newWindow.backgroundColor = NSColor.clear
        
        newTextField.preferredMaxLayoutWidth = (nsScreen.visibleFrame.size.width - 50).clamped(to: 1...)
        newTextField.isBordered = false
        newTextField.isEditable = false
        newTextField.isSelectable = false
        newTextField.drawsBackground = false
        newTextField.alignment = .center
        newTextField.usesSingleLineMode = false
        newTextField.cell?.wraps = true
        // if alert fills screen, truncate it with ellipsis
        newTextField.cell?.truncatesLastVisibleLine = true
        newView.autoresizesSubviews = true // doesn't affect anything
        
        newTextField.translatesAutoresizingMaskIntoConstraints = false
        newView.addConstraint(.init(
            item: newTextField as Any,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: newView,
            attribute: .centerY,
            multiplier: 1,
            constant: 0
        ))
        newView.addConstraint(.init(
            item: newTextField as Any,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: newView,
            attribute: .centerX,
            multiplier: 1,
            constant: 0
        ))
        newView.addConstraint(.init(
            item: newTextField as Any,
            attribute: .width,
            relatedBy: .equal,
            toItem: newTextField,
            attribute: .width,
            multiplier: 1,
            constant: 0
        ))
        newView.addConstraint(.init(
            item: newTextField as Any,
            attribute: .height,
            relatedBy: .equal,
            toItem: newTextField,
            attribute: .height,
            multiplier: 1,
            constant: 0
        ))
        newWindow.maxSize = nsScreen.frame.size
        
        newView.wantsLayer = true // needed to enable corner radius mask
        newView.layer?.masksToBounds = true
        newView.layer?.cornerRadius = 20
        newView.layerUsesCoreImageFilters = true //  doesn't affect things?
        
        newWindow.contentMaxSize = screenRect.size
        
        // Apple's dark translucent blur effect
        newWindow.backgroundColor = NSColor.clear
        let newBlurEffectView = NSVisualEffectView()
        newView.addSubview(newBlurEffectView, positioned: .below, relativeTo: newView)
        
        newBlurEffectView.state = .active
        newBlurEffectView.blendingMode = .behindWindow
        newBlurEffectView.frame = newView.bounds // always fill the view
        newBlurEffectView.autoresizingMask = [.width, .height]
        
        // animating CIFilters needs to be added to the view’s filters array, not the layer’s content or background filters arrays.
        let blurFilter = CIFilter(
            name: "CIMotionBlur",
            parameters: [kCIInputRadiusKey: 0]
        )
        if let blurFilter {
            newView.contentFilters.append(blurFilter)
        }
        
        return (window: newWindow, view: newView, visualEffectView: newBlurEffectView, blurFilter: blurFilter, textField: newTextField)
    }
    
    /// Updates the reusable window with new parameters.
    @MainActor
    func _updateWindow(
        message: String,
        position: HUDStyle.Position = .center,
        size: HUDStyle.Size = .medium,
        tint: HUDStyle.Tint = .dark,
        isBordered: Bool = false
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
        guard let hudViewCIMotionBlur else {
            throw HUDError.internalInconsistency("Missing HUD alert motion blur filter.")
        }
        guard let hudTextField else {
            throw HUDError.internalInconsistency("Missing HUD alert text field.")
        }
        
        // grab first screen
        // (not .main) because .main will reference focused screen if user has "Displays have separate Spaces" enabled in System Preferences -> Mission Control
        guard let nsScreenFirst = NSScreen.screens.first else {
            throw HUDError.internalInconsistency("Can't get reference to main screen.")
        }
        
        // determine maximum size for alert
        let screenMainFrame = nsScreenFirst.visibleFrame
        
        // origin is bottom left of screen. Y axis goes up, X axis goes right.
        let screenRect = NSRect(
            x:      screenMainFrame.origin.x + 50, // to right
            y:      screenMainFrame.origin.y + 50, // up
            width:  screenMainFrame.width   - 100,
            height: screenMainFrame.height  - 100
        )
        
        // set text to display
        hudTextField.stringValue = message
        
        // theme / formatting customization
        
        var borderWidth = 0
        
        switch size {
        case .small:
            hudTextField.font = NSFont(name: hudTextField.font?.fontName ?? "", size: 20)
            borderWidth = 1
        case .medium:
            hudTextField.font = NSFont(name: hudTextField.font?.fontName ?? "", size: 60)
            borderWidth = 3
        case .large:
            hudTextField.font = NSFont(name: hudTextField.font?.fontName ?? "", size: 100)
            borderWidth = 5
        case .superLarge:
            hudTextField.font = NSFont(name: hudTextField.font?.fontName ?? "", size: 150)
            borderWidth = 5
        }
        
        switch tint {
        case .light, .mediumLight:
            hudTextField.textColor = #colorLiteral(red: 0.08749181937, green: 0.08749181937, blue: 0.08749181937, alpha: 1)
            
        case .dark, .ultraDark:
            hudTextField.textColor = #colorLiteral(red: 0.7602152824, green: 0.7601925135, blue: 0.7602053881, alpha: 1)
        }
        
        if isBordered {
            switch tint {
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
        
        // prepare text object's initial size
        hudTextField.sizeToFit()
        
        // constrain size to fit inside main screen
        if hudTextField.frame.width > screenRect.width {
            hudTextField
                .setFrameSize(NSSize(width: screenRect.width, height: hudTextField.frame.width))
        }
        if hudTextField.frame.height > screenRect.height {
            hudTextField
                .setFrameSize(NSSize(
                    width: hudTextField.frame.width,
                    height: screenRect.height
                ))
        }
        
        var displayBounds = NSMakeRect(
            (screenMainFrame.size.width - hudTextField.frame.size.width - 40) * 0.5,
            0,
            hudTextField.frame.size.width + 40,
            hudTextField.frame.size.height + 40
        )
        switch position {
        case .bottom:
            displayBounds.origin.y = 150
        case .center:
            displayBounds.origin.y = (screenMainFrame.size.height - hudTextField.frame.size.height - 40) * 0.5
        case .top:
            displayBounds.origin.y = (screenMainFrame.size.height - hudTextField.frame.size.height - 40 - 150)
        }
        
        // apply sizes
        hudWindow.setFrame(displayBounds, display: true)
        hudWindow.setFrame(
            hudWindow.constrainFrameRect(hudWindow.frame, to: nsScreenFirst),
            display: true
        )
        
        // hudViewVisualEffectView (NSVisualEffectView)
        switch tint {
        case .light:
            hudViewVisualEffectView.material = .light
        case .mediumLight:
            hudViewVisualEffectView.material = .mediumLight
        case .dark:
            hudViewVisualEffectView.material = .dark
        case .ultraDark:
            hudViewVisualEffectView.material = .ultraDark
        }
        
        // hudViewCIMotionBlur (CIFilter)
        
        // reset blur value to default
        hudViewCIMotionBlur.setValue(0, forKeyPath: kCIInputRadiusKey)
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
}
