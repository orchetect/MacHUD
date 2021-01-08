//
//  OTHUDNotification.swift
//  HUDKit
//
//  Created by Steffan Andrews on 2020-09-23.
//

import Cocoa
@_implementationOnly import OTCore
@_implementationOnly import OTShared

extension OTHUDControllerHost {
	
	/// Represents a HUD notification object.
	/// Instanced to generate a notification, and auto-deallocates when done.
	internal class OTHUDNotification {
		
		var hudWindow: NSWindow
		var hudView: NSView!
		var hudTextField: NSTextField!
		
		var delayTask: OTTimeUtils.Task?
		
		//		var createdAtTime: Date? = Date() // attach a creation date in order to establish precedence in notifications array
		
		var uniqueID: Int?
		
		init() {
			// increment perpetual counter
			if OTHUDControllerHost.shared.perpetualInstanceCounter > 1000 { OTHUDControllerHost.shared.perpetualInstanceCounter = 0 } // wrap at 1000
			self.uniqueID = OTHUDControllerHost.shared.perpetualInstanceCounter + 1
			OTHUDControllerHost.shared.perpetualInstanceCounter += 1
			
			self.hudWindow = NSWindow(contentRect: NSMakeRect(0, 0, 500, 160), styleMask: NSWindow.StyleMask.borderless, backing: .buffered, defer: false)
			self.hudView = NSView()
			self.hudTextField = NSTextField()
		}
		
		deinit {
			// not deallocating stuff here, doing it in killClass()
			
			//			llog("HUD instance deinit")
		}
		
		
		func showHUD(msg: String ,
					 stickyTime: TimeInterval = 3,
					 position: OTHUDPosition = .center,
					 size: OTHUDSize = .medium,
					 style: OTHUDStyle = .dark,
					 bordered: Bool = false,
					 fadeOut: OTHUDFade = .defaultDuration
		) {
			
			// set up UI
			//			window = NSWindow(contentRect: NSMakeRect(0, 0, 500, 160), styleMask: NSBorderlessWindowMask, backing: .buffered, defer: false)
			//		hudWindow.styleMask = .hudWindow // don't make HID window - it disappears on app deactivation!
			hudWindow.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(CGWindowLevelKey.assistiveTechHighWindow)))
			hudWindow.isOpaque = false
			hudWindow.backgroundColor = NSColor.clear
			hudWindow.ignoresMouseEvents = true
			hudWindow.isExcludedFromWindowsMenu = true
			hudWindow.collectionBehavior = [NSWindow.CollectionBehavior.ignoresCycle, NSWindow.CollectionBehavior.stationary, NSWindow.CollectionBehavior.moveToActiveSpace] // excludes from Exposé
			
			//			hudView = NSView()
			
			//			hudTextField = NSTextField()
			hudTextField.preferredMaxLayoutWidth = (NSScreen.main?.visibleFrame.size.width ?? 1000) - 50
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
			hudView.addConstraint(NSLayoutConstraint(item: hudTextField as Any, attribute: .centerY, relatedBy: .equal , toItem: hudView, attribute: .centerY, multiplier: 1, constant: 0))
			hudView.addConstraint(NSLayoutConstraint(item: hudTextField as Any, attribute: .centerX, relatedBy: .equal , toItem: hudView, attribute: .centerX, multiplier: 1, constant: 0))
			hudView.addConstraint(NSLayoutConstraint(item: hudTextField as Any, attribute: .width, relatedBy: .equal , toItem: hudTextField, attribute: .width, multiplier: 1, constant: 0))
			hudView.addConstraint(NSLayoutConstraint(item: hudTextField as Any, attribute: .height, relatedBy: .equal , toItem: hudTextField, attribute: .height, multiplier: 1, constant: 0))
			hudWindow.maxSize = (NSScreen.main?.frame.size)!
			
			hudWindow.contentView? = hudView
			hudWindow.contentView?.wantsLayer = true
			hudWindow.contentView?.layer?.masksToBounds = true
			hudWindow.contentView?.layer?.cornerRadius = 20
			hudView.layerUsesCoreImageFilters = true //  doesn't affect things?
			
			hudWindow.makeKey()
			
			
			// determine maximum size for notification
			guard let screenMainFrame = NSScreen.main?.visibleFrame else { return }
			
			// origin is bottom left of screen. Y axis goes up, X axis goes right.
			let screenRect = NSRect(
				x:      screenMainFrame.origin.x + 50, // to right
				y:      screenMainFrame.origin.y + 50, // up
				width:  screenMainFrame.width   - 100,
				height: screenMainFrame.height  - 100)
			
			hudWindow.contentMaxSize = screenRect.size
			
			OTTimeUtils.cancel(delayTask)
			
			// set text to display
			hudTextField.stringValue = msg
			
			// theme / formatting customization
			var borderWidth = 0
			switch size {
			case .small:
				hudTextField.font = NSFont(name: (hudTextField.font?.fontName)!, size: 20)
				borderWidth = 1
			case .medium:
				hudTextField.font = NSFont(name: (hudTextField.font?.fontName)!, size: 60)
				borderWidth = 3
			case .large:
				hudTextField.font = NSFont(name: (hudTextField.font?.fontName)!, size: 100)
				borderWidth = 5
			case .superLarge:
				hudTextField.font = NSFont(name: (hudTextField.font?.fontName)!, size: 150)
				borderWidth = 5
			}
			
			switch style {
			case .light, .mediumLight:
				hudTextField.textColor = #colorLiteral(red: 0.08749181937, green: 0.08749181937, blue: 0.08749181937, alpha: 1)
				//	hudView.layer?.backgroundColor = NSColor.lightGray().withAlphaComponent(0.85).cgColor
				if bordered {
					hudView.layer?.borderWidth = CGFloat(borderWidth)
					hudView.layer?.borderColor = NSColor(red:0.15, green:0.16, blue:0.17, alpha:1.00).cgColor
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
			
			var displayBounds = NSMakeRect((screenMainFrame.size.width - hudTextField.frame.size.width - 40) * 0.5, 0, hudTextField.frame.size.width + 40, hudTextField.frame.size.height + 40 )
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
			hudWindow.setFrame(hudWindow.constrainFrameRect(hudWindow.frame, to: NSScreen.main), display: true)
			
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
			
			// show notification
			hudWindow.makeKeyAndOrderFront(self)
			
			// remain on screen for specified time period; schedule the fade out
			delayTask = OTTimeUtils.delay(stickyTime) {
				self.hideHUD(fadeOut)
			}!
			
			// animate notification appearing
			self.hudWindow.alphaValue = 0
			NSAnimationContext.runAnimationGroup({ context in
				context.duration = 0.1
				self.hudWindow.animator().alphaValue = 1
			}) {
				
			}
		}
		
		internal func hideHUD(_ fade: OTHUDFade = .defaultDuration) {
			var fadeTime: Double = 0.2
			
			switch fade {
			case .noFade:
				hudWindow.orderOut(self)
				killClass()
				return
			case .defaultDuration:
				break // leave default value
			case let .withDuration(ft):
				fadeTime = ft.clamped(to: 0.01...5.0)
			}
			
			// animating CIFilters needs to be added to the view’s filters array, not the layer’s content or background filters arrays.
			if let bfilter = CIFilter(name: "CIMotionBlur", parameters: [kCIInputRadiusKey : 0]) {
				self.hudView.contentFilters.append(bfilter) }
			
			// begin async animation event
			NSAnimationContext.runAnimationGroup({ context in
				context.duration = fadeTime
				context.allowsImplicitAnimation = true // doesn't affect things?
				self.hudWindow.animator().alphaValue = 0
				self.hudWindow.contentView?.animator().contentFilters[0].setValue(1.5, forKey: kCIInputRadiusKey) // CIMotionBlur does not animate here - have to discover a way to animate CIFilter properties.
				
			}) {
				self.hudWindow.orderOut(self)
				self.hudWindow.alphaValue = 0
				self.killClass()
				
			}
			
		}
		
		internal func killClass() {
			//			llog("HUD killClass() fired.")
			
			/// attempts to trigger a deinit() by destroying any references inside the class
			//delayTask = nil
			//hudTextField = nil
			//hudView = nil
			//hudWindow = nil
			if let idx = shared.OTHUDNotifications.firstIndex(where: { $0 == self }) {
				shared.OTHUDNotifications.remove(at: idx) // remove from array
			} else { llog(level: .err, "HUD notiication class deinit: couldn't remove from manager array. Possible memory leak may result.") }
			self.uniqueID = nil
			
			//			llog("HUD notifications array count:", sharedInstance.OTHUDNotifications.count)
		}
		
	}
	
}

extension OTHUDControllerHost.OTHUDNotification: Equatable {
	
	static func ==(lhs: OTHUDControllerHost.OTHUDNotification,
				   rhs: OTHUDControllerHost.OTHUDNotification) -> Bool {
		
		lhs.uniqueID == rhs.uniqueID
		
	}
	
}
