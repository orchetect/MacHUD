//
//  HUDManager Alert+Private.swift
//  swift-hud • https://github.com/orchetect/swift-hud
//

import AppKit
internal import SwiftExtensions

extension HUDManager.Alert {
    /// Creates the initial alert window.
    @MainActor
    func _create() throws {
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
        
        hudWindow.styleMask = [.borderless] // already set at window creation, above
        hudWindow.level = .screenSaver
        // hudWindow.canBecomeKey = false // read-only
        // hudWindow.canBecomeMain = false // read-only
        hudWindow.hidesOnDeactivate = false
        
        hudWindow.ignoresMouseEvents = true
        hudWindow.isExcludedFromWindowsMenu = true
        hudWindow.allowsToolTipsWhenApplicationIsInactive = false
        // excludes from Exposé
        hudWindow.collectionBehavior = [
            .ignoresCycle, .stationary, .canJoinAllSpaces,
            .fullScreenAuxiliary, .transient
        ]
        
        hudWindow.isOpaque = false
        hudWindow.backgroundColor = NSColor.clear
        
        hudTextField.preferredMaxLayoutWidth = (nsScreen.visibleFrame.size.width - 50).clamped(to: 1...)
        hudTextField.isBordered = false
        hudTextField.isEditable = false
        hudTextField.isSelectable = false
        hudTextField.drawsBackground = false
        hudTextField.alignment = .center
        hudTextField.usesSingleLineMode = false
        hudTextField.cell?.wraps = true
        // if alert fills screen, truncate it with ellipsis
        hudTextField.cell?.truncatesLastVisibleLine = true
        hudView.autoresizesSubviews = true // doesn't affect anything
        
        hudTextField.translatesAutoresizingMaskIntoConstraints = false
        hudView.addConstraint(.init(
            item: hudTextField as Any,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: hudView,
            attribute: .centerY,
            multiplier: 1,
            constant: 0
        ))
        hudView.addConstraint(.init(
            item: hudTextField as Any,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: hudView,
            attribute: .centerX,
            multiplier: 1,
            constant: 0
        ))
        hudView.addConstraint(.init(
            item: hudTextField as Any,
            attribute: .width,
            relatedBy: .equal,
            toItem: hudTextField,
            attribute: .width,
            multiplier: 1,
            constant: 0
        ))
        hudView.addConstraint(.init(
            item: hudTextField as Any,
            attribute: .height,
            relatedBy: .equal,
            toItem: hudTextField,
            attribute: .height,
            multiplier: 1,
            constant: 0
        ))
        hudWindow.maxSize = nsScreen.frame.size
        
        hudView.wantsLayer = true // needed to enable corner radius mask
        hudView.layer?.masksToBounds = true
        hudView.layer?.cornerRadius = 20
        hudView.layerUsesCoreImageFilters = true //  doesn't affect things?
        
        hudWindow.contentMaxSize = screenRect.size
        
        // ---- snip -----
        
        // add soft blur effect behind text ?? - tried this before succeeding with NSVisualEffectView
        //        if let bfilter = CIFilter(name: "CIGaussianBlur", withInputParameters: [kCIInputRadiusKey : 13]) {
        //            self.hudView.backgroundFilters.append(bfilter) }
        
        // Apple's dark translucent blur effect
        hudWindow.backgroundColor = NSColor.clear
        let blurEffectView = NSVisualEffectView()
        hudView_VisualEffectView = blurEffectView
        hudView.addSubview(blurEffectView, positioned: .below, relativeTo: hudView)
        
        hudView_VisualEffectView?.state = .active
        
        hudView_VisualEffectView?.blendingMode = .behindWindow
        hudView_VisualEffectView?.frame = hudView.bounds // always fill the view
        hudView_VisualEffectView?.autoresizingMask = [.width, .height]
        
        // animating CIFilters needs to be added to the view’s filters array, not the layer’s content or background filters arrays.
        if let bfilter = CIFilter(
            name: "CIMotionBlur",
            parameters: [kCIInputRadiusKey: 0]
        ) {
            hudView_CIMotionBlur = bfilter
            self.hudView.contentFilters.append(bfilter)
        }
    }
    
    /// Updates the UI with new parameters after ``create()`` has been called.
    @MainActor
    func _update(
        msg: String,
        position: HUDStyle.Position = .center,
        size: HUDStyle.Size = .medium,
        shade: HUDStyle.Shade = .dark,
        isBordered: Bool = false
    ) throws {
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
        hudTextField.stringValue = msg
        
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
        
        switch shade {
        case .light, .mediumLight:
            hudTextField.textColor = #colorLiteral(red: 0.08749181937, green: 0.08749181937, blue: 0.08749181937, alpha: 1)
            
        case .dark, .ultraDark:
            hudTextField.textColor = #colorLiteral(red: 0.7602152824, green: 0.7601925135, blue: 0.7602053881, alpha: 1)
        }
        
        if isBordered {
            switch shade {
            case .light, .mediumLight:
                hudView.layer?.borderWidth = CGFloat(borderWidth)
                hudView.layer?.borderColor = NSColor(
                    red: 0.15,
                    green: 0.16,
                    blue: 0.17,
                    alpha: 1.00
                ).cgColor
                
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
        
        // hudView_VisualEffectView (NSVisualEffectView)
        switch shade {
        case .light:
            hudView_VisualEffectView?.material = .light
        case .mediumLight:
            hudView_VisualEffectView?.material = .mediumLight
        case .dark:
            hudView_VisualEffectView?.material = .dark
        case .ultraDark:
            hudView_VisualEffectView?.material = .ultraDark
        }
        
        // hudView_CIMotionBlur (CIFilter)
        
        // reset blur value to default
        hudView_CIMotionBlur?.setValue(0, forKeyPath: kCIInputRadiusKey)
    }
    
    /// Shows the alert on screen, animating its appearance using the `fadeIn` parameter. (Default recommended)
    @MainActor
    func _show(
        fadeIn: TimeInterval = 0.05,
        stickyTime: TimeInterval = 3.0,
        fadeOut: HUDStyle.Fade = .default
    ) async {
        // show alert
        hudWindow.orderFront(self)
        
        // NOTE: Animations will not work unless called on main thread/actor
        
        // animate alert appearing
        hudWindow.alphaValue = 0
        await NSAnimationContext.runAnimationGroup { context in
            context.duration = fadeIn
            self.hudWindow.animator().alphaValue = 1
        }
        
        // remain on screen for specified time period; schedule the fade out
        // prevent time values being too small as failsafe
        let stickyTime = stickyTime.clamped(to: 0.1...)
        try? await Task.sleep(seconds: stickyTime)
        
        // dismiss
        do {
            try await dismiss(fade: fadeOut)
        } catch {
            logger.debug("Error dismissing HUD alert: \(error.localizedDescription)")
        }
    }
}
