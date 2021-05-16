//
//  HUD Notification.swift
//  HUDKit
//
//  Created by Steffan Andrews on 2020-09-23.
//  Copyright © 2020 Steffan Andrews. All rights reserved.
//

import AppKit
@_implementationOnly import OTCore

extension HUD {
	
	/// Represents a HUD notification object.
	/// Instanced to generate a notification, and auto-deallocates when done.
	internal class Notification {
		
		var hudWindow: NSWindow
		var hudView: NSView!
		var hudTextField: NSTextField!
		
		//var createdAtTime: Date? = Date() // attach a creation date in order to establish precedence in notifications array
		
		var uniqueID: Int
		
		init() {
			
			// increment perpetual counter
			if Controller.shared.perpetualInstanceCounter > 1000 {
				// wrap at 1000
				Controller.shared.perpetualInstanceCounter = 0
			}
			self.uniqueID = Controller.shared.perpetualInstanceCounter + 1
			Controller.shared.perpetualInstanceCounter += 1
			
			self.hudWindow = NSWindow(contentRect: NSMakeRect(0, 0, 500, 160),
									  styleMask: NSWindow.StyleMask.borderless,
									  backing: .buffered,
									  defer: false)
			self.hudView = NSView()
			self.hudTextField = NSTextField()
			
		}
		
		deinit {
			// not deallocating stuff here, doing it in killClass()
			
			//Log.debug("HUD instance deinit")
		}
		
	}
	
}

extension HUD.Notification {
	
	/// Creates the notification window and shows it on screen.
	internal func createAndShow(
		msg: String,
		stickyTime: TimeInterval = 3,
		position: HUD.Position = .center,
		size: HUD.Size = .medium,
		style: HUD.Style = .dark,
		bordered: Bool = false,
		fadeOut: HUD.Fade = .defaultDuration
	) throws {
		
		try __create(msg: msg,
				 position: position,
				 size: size,
				 style: style,
				 bordered: bordered)
		
		__show(stickyTime: stickyTime,
			   fadeOut: fadeOut)
		
	}
	
	/// Creates the notification window.
	fileprivate func __create(
		msg: String,
		position: HUD.Position = .center,
		size: HUD.Size = .medium,
		style: HUD.Style = .dark,
		bordered: Bool = false
	) throws {
		
		guard let nsScreenMain = NSScreen.main else {
			throw HUD.HUDError.internalInconsistency("Can't get reference to main screen.")
		}
		
		// set up UI
		//window = NSWindow(contentRect: NSMakeRect(0, 0, 500, 160), styleMask: NSBorderlessWindowMask, backing: .buffered, defer: false)
		//hudWindow.styleMask = .hudWindow // don't make HID window - it disappears on app deactivation!
		hudWindow.level = NSWindow.Level(rawValue: CGWindowLevelForKey(.assistiveTechHighWindow).int)
		hudWindow.isOpaque = false
		hudWindow.backgroundColor = NSColor.clear
		hudWindow.ignoresMouseEvents = true
		hudWindow.isExcludedFromWindowsMenu = true
		// excludes from Exposé
		hudWindow.collectionBehavior = [.ignoresCycle, .stationary, .moveToActiveSpace]
		
		//hudView = NSView()
		
		//hudTextField = NSTextField()
		hudTextField.preferredMaxLayoutWidth = (nsScreenMain.visibleFrame.size.width - 50).clamped(to: 1...)
		hudTextField.isBordered = false
		hudTextField.isEditable = false
		hudTextField.isSelectable = false
		hudTextField.drawsBackground = false
		hudTextField.alignment = .center
		hudTextField.usesSingleLineMode = false
		hudTextField.cell?.wraps = true
		hudTextField.cell?.truncatesLastVisibleLine = true // if notification fills screen, truncate it with ellipsis
		hudView.autoresizesSubviews = true // doesn't affect anything
		hudView.addSubview(hudTextField)
		
		hudTextField.translatesAutoresizingMaskIntoConstraints = false
		hudView.addConstraint(.init(item: hudTextField as Any,
									attribute: .centerY,
									relatedBy: .equal,
									toItem: hudView,
									attribute: .centerY,
									multiplier: 1,
									constant: 0))
		hudView.addConstraint(.init(item: hudTextField as Any,
									attribute: .centerX,
									relatedBy: .equal,
									toItem: hudView,
									attribute: .centerX,
									multiplier: 1,
									constant: 0))
		hudView.addConstraint(.init(item: hudTextField as Any,
									attribute: .width,
									relatedBy: .equal,
									toItem: hudTextField,
									attribute: .width,
									multiplier: 1,
									constant: 0))
		hudView.addConstraint(.init(item: hudTextField as Any,
									attribute: .height,
									relatedBy: .equal,
									toItem: hudTextField,
									attribute: .height,
									multiplier: 1,
									constant: 0))
		hudWindow.maxSize = nsScreenMain.frame.size
		
		hudWindow.contentView? = hudView
		hudWindow.contentView?.wantsLayer = true
		hudWindow.contentView?.layer?.masksToBounds = true
		hudWindow.contentView?.layer?.cornerRadius = 20
		hudView.layerUsesCoreImageFilters = true //  doesn't affect things?
		
		hudWindow.makeKey()
		
		
		// determine maximum size for notification
		let screenMainFrame = nsScreenMain.visibleFrame
		
		// origin is bottom left of screen. Y axis goes up, X axis goes right.
		let screenRect = NSRect(
			x:      screenMainFrame.origin.x + 50, // to right
			y:      screenMainFrame.origin.y + 50, // up
			width:  screenMainFrame.width   - 100,
			height: screenMainFrame.height  - 100
		)
		
		hudWindow.contentMaxSize = screenRect.size
		
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
		
		switch style {
		case .light, .mediumLight:
			hudTextField.textColor = #colorLiteral(red: 0.08749181937, green: 0.08749181937, blue: 0.08749181937, alpha: 1)
			//	hudView.layer?.backgroundColor = NSColor.lightGray().withAlphaComponent(0.85).cgColor
			if bordered {
				hudView.layer?.borderWidth = CGFloat(borderWidth)
				hudView.layer?.borderColor = NSColor(red: 0.15, green: 0.16, blue: 0.17, alpha: 1.00).cgColor
			} else {
				hudView.layer?.borderWidth = 0
			}
		case .dark, .ultraDark:
			hudTextField.textColor = #colorLiteral(red: 0.7602152824, green: 0.7601925135, blue: 0.7602053881, alpha: 1)
			//	hudView.layer?.backgroundColor = NSColor(hue:0.00, saturation:0.00, brightness:0.16, alpha:0.85).cgColor // #colorLiteral(red: 0.1956433058, green: 0.2113749981, blue: 0.2356699705, alpha: 1).withAlphaComponent(0.8).cgColor
			if bordered {
				hudView.layer?.borderWidth = CGFloat(borderWidth)
				hudView.layer?.borderColor = NSColor.white.cgColor
			} else {
				hudView.layer?.borderWidth = 0
			}
		}
		
		// prepare text object's initial size
		hudTextField.sizeToFit()
		
		// constrain size to fit inside main screen
		if hudTextField.frame.width > screenRect.width {
			hudTextField.setFrameSize(NSSize(width: screenRect.width, height: hudTextField.frame.width))
		}
		if hudTextField.frame.height > screenRect.height {
			hudTextField.setFrameSize(NSSize(width: hudTextField.frame.width, height: screenRect.height))
		}
		
		var displayBounds = NSMakeRect((screenMainFrame.size.width - hudTextField.frame.size.width - 40) * 0.5,
									   0,
									   hudTextField.frame.size.width + 40,
									   hudTextField.frame.size.height + 40 )
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
		hudWindow.setFrame(hudWindow.constrainFrameRect(hudWindow.frame, to: nsScreenMain), display: true)
		
		// add soft blur effect behind text ?? - tried this before succeeding with NSVisualEffectView
		//		if let bfilter = CIFilter(name: "CIGaussianBlur", withInputParameters: [kCIInputRadiusKey : 13]) {
		//			self.hudView.backgroundFilters.append(bfilter) }
		
		// Apple's dark translucent blur effect
		hudWindow.backgroundColor = NSColor.clear
		let blurEffectView = NSVisualEffectView()
		blurEffectView.state = .active
		switch style {
		case .light: blurEffectView.material = .light
		case .mediumLight: blurEffectView.material = .mediumLight
		case .dark: blurEffectView.material = .dark
		case .ultraDark: blurEffectView.material = .ultraDark
		}
		blurEffectView.blendingMode = .behindWindow
		blurEffectView.frame = hudView.bounds //always fill the view
		blurEffectView.autoresizingMask = [NSView.AutoresizingMask.width, NSView.AutoresizingMask.height]
		hudView.addSubview(blurEffectView, positioned: .below, relativeTo: hudView)
		
	}
	
	/// Shows it on screen.
	fileprivate func __show(
		stickyTime: TimeInterval = 3,
		fadeOut: HUD.Fade = .defaultDuration
	) {
		
		// show notification
		hudWindow.makeKeyAndOrderFront(self)
		
		// remain on screen for specified time period; schedule the fade out
		DispatchQueue.main.asyncAfterDelta(stickyTime) { [weak self] in
			try? self?.dismiss(fadeOut)
		}
		
		// animate notification appearing
		self.hudWindow.alphaValue = 0
		NSAnimationContext.runAnimationGroup(
			{ [weak self] context in
				context.duration = 0.1
				self?.hudWindow.animator().alphaValue = 1
				
			}, completionHandler: {
				// empty
			}
		)
		
	}
	
	/// Triggers notification dismissal, animating out, and disposing of its resources.
	internal func dismiss(
		_ fade: HUD.Fade = .defaultDuration
	) throws {
		
		var fadeTime: Double = 0.2
		
		switch fade {
		case .noFade:
			hudWindow.orderOut(self)
			try __killClass()
			return
		case .defaultDuration:
			break // leave default value
		case let .withDuration(ft):
			fadeTime = ft.clamped(to: 0.01...5.0)
		}
		
		// animating CIFilters needs to be added to the view’s filters array, not the layer’s content or background filters arrays.
		if let bfilter = CIFilter(name: "CIMotionBlur",
								  parameters: [kCIInputRadiusKey : 0])
		{
			
			self.hudView.contentFilters.append(bfilter)
			
		}
		
		// begin async animation event
		NSAnimationContext.runAnimationGroup(
			{ [weak self] context in
				context.duration = fadeTime
				context.allowsImplicitAnimation = true // doesn't affect things?
				self?.hudWindow.animator().alphaValue = 0
				
				// CIMotionBlur does not animate here - have to discover a way to animate CIFilter properties.
				self?.hudWindow.contentView?.animator().contentFilters.first?
					.setValue(1.5, forKey: kCIInputRadiusKey)
				
			}, completionHandler: { [weak self] in
				self?.hudWindow.orderOut(self)
				self?.hudWindow.alphaValue = 0
				try? self?.__killClass()
				
			}
		)
		
	}
	
}

extension HUD.Notification {
	
	fileprivate func __killClass() throws {
		
		//Log.debug("HUD killClass() fired.")
		
		/// attempts to trigger a deinit() by destroying any references inside the class
		//delayTask = nil
		//hudTextField = nil
		//hudView = nil
		//hudWindow = nil
		if let idx = HUD.Controller.shared.notifications
			.firstIndex(where: { $0 == self })
		{
			
			// remove from array
			HUD.Controller.shared.notifications.remove(at: idx)
			
		} else {
			
			throw HUD.HUDError.internalInconsistency("HUD notification class deinit: couldn't remove from manager array. Possible memory leak may result.")
			
		}
		
		//Log.debug("HUD notifications array count:", sharedInstance.OTHUDNotifications.count)
		
	}
	
}

extension HUD.Notification: Equatable {
	
	static func == (lhs: HUD.Notification, rhs: HUD.Notification) -> Bool {
		
		lhs.uniqueID == rhs.uniqueID
		
	}
	
}
