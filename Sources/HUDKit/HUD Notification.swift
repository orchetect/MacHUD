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
		
		let uuid = UUID()
		
		var inUse = false
		
		var created = false
		
		// MARK: - UI
		
		var hudWindow: NSWindow!
		
		weak var hudView: NSView!
		weak var hudView_VisualEffectView: NSVisualEffectView? = nil
		weak var hudView_CIMotionBlur: CIFilter? = nil
		
		weak var hudTextField: NSTextField!
		
//		var animGroup: CAAnimationGroup? = nil
		
		// MARK: - Init
		
		init() {
			
			autoreleasepool {
				
				self.hudWindow = NSWindow(contentRect: NSMakeRect(0, 0, 500, 160),
										  styleMask: .borderless,
										  backing: .buffered,
										  defer: true)
				
				self.hudView = hudWindow.contentView
				
				let newTextField = NSTextField()
				self.hudTextField = newTextField
				hudView.addSubview(hudTextField)
				
				hudWindow.contentView? = hudView
				hudWindow.isOneShot = false
				
				if (try? __create()) != nil { created = true }
				
			}
			
		}
		
		deinit {
			//Log.debug("HUD instance deinit")
		}
		
	}
	
}

// MARK: - Methods

extension HUD.Notification {
	
	/// Creates the notification window and shows it on screen.
	internal func show(
		msg: String,
		style: HUD.Style
	) throws {
		
		guard created else {
			inUse = false
			throw HUD.HUDError.internalInconsistency("Notification class was not created.")
		}
		
		if inUse {
			// do a basic reset of the window if it's currently in use
			hudWindow.orderOut(self)
			hudWindow.alphaValue = 0
			
			// this may not be necessary or may not do anything useful; the assumption is that is cancels any already in-progress animation but it hasn't been confirmed that it actually does that yet
			NSAnimationContext.runAnimationGroup(
				{ context in
					context.duration = 0.0
				},
				completionHandler: nil
			)
		}
		
		inUse = true
		
		try autoreleasepool {
			
			do {
				try __modify(msg: msg,
							 position: style.position,
							 size: style.size,
							 shade: style.shade,
							 bordered: style.bordered)
				
				__show(stickyTime: style.stickyTime,
					   fadeOut: style.fadeOut)
			} catch {
				inUse = false
				throw error
			}
			
		}
		
	}
	
	/// Triggers notification dismissal, animating out, and disposing of its resources.
	internal func dismiss(
		_ fade: HUD.Style.Fade = .defaultDuration
	) throws {
		
		autoreleasepool {
			
			var fadeTime: TimeInterval = 0.2
			
			switch fade {
			case .noFade:
				hudWindow.orderOut(self)
				inUse = false
				return
				
			case .defaultDuration:
				break // leave default value
			
			case let .withDuration(ft):
				fadeTime = ft.clamped(to: 0.01...5.0)
				
			}
			
			// begin async animation event
			NSAnimationContext.runAnimationGroup(
				{ [weak self] context in
					autoreleasepool {
						context.duration = fadeTime
						context.allowsImplicitAnimation = true // doesn't affect things?
						self?.hudWindow.animator().alphaValue = 0
						
						// CIMotionBlur does not animate here - have to discover a way to animate CIFilter properties.
						self?.hudView.animator().contentFilters.first?
							.setValue(1.5, forKey: kCIInputRadiusKey)
					}
				}, completionHandler: { [weak self] in
					autoreleasepool {
						self?.hudWindow.orderOut(self)
						self?.hudWindow.alphaValue = 0
						self?.inUse = false
					}
				}
			)
			
		}
		
	}
	
}

// MARK: - Private Methods

extension HUD.Notification {

	/// Creates the notification window.
	fileprivate func __create() throws {
		
		try autoreleasepool {
			
			// grab first screen
			// (not .main) because .main will reference focused screen if user has "Displays have separate Spaces" enabled in System Preferences -> Mission Control
			guard let nsScreenFirst = NSScreen.screens.first else {
				throw HUD.HUDError.internalInconsistency("Can't get reference to main screen.")
			}
			
			// determine maximum size for notification
			let screenMainFrame = nsScreenFirst.visibleFrame
			
			// origin is bottom left of screen. Y axis goes up, X axis goes right.
			let screenRect = NSRect(
				x:      screenMainFrame.origin.x + 50, // to right
				y:      screenMainFrame.origin.y + 50, // up
				width:  screenMainFrame.width   - 100,
				height: screenMainFrame.height  - 100
			)
			
			// set up UI
			//window = NSWindow(contentRect: NSMakeRect(0, 0, 500, 160), styleMask: NSBorderlessWindowMask, backing: .buffered, defer: false)
			//hudWindow.styleMask = .hudWindow // don't make HID window - it disappears on app deactivation!
			hudWindow.level = .init(rawValue: CGWindowLevelForKey(.assistiveTechHighWindow).int)
			hudWindow.isOpaque = false
			hudWindow.backgroundColor = NSColor.clear
			hudWindow.ignoresMouseEvents = true
			hudWindow.isExcludedFromWindowsMenu = true
			// excludes from Exposé
			hudWindow.collectionBehavior = [.ignoresCycle, .stationary, .moveToActiveSpace]
			
			hudTextField.preferredMaxLayoutWidth = (nsScreenFirst.visibleFrame.size.width - 50).clamped(to: 1...)
			hudTextField.isBordered = false
			hudTextField.isEditable = false
			hudTextField.isSelectable = false
			hudTextField.drawsBackground = false
			hudTextField.alignment = .center
			hudTextField.usesSingleLineMode = false
			hudTextField.cell?.wraps = true
			// if notification fills screen, truncate it with ellipsis
			hudTextField.cell?.truncatesLastVisibleLine = true
			hudView.autoresizesSubviews = true // doesn't affect anything
			
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
			hudWindow.maxSize = nsScreenFirst.frame.size
			
			hudView.wantsLayer = true // needed to enable corner radius mask
			hudView.layer?.masksToBounds = true
			hudView.layer?.cornerRadius = 20
			hudView.layerUsesCoreImageFilters = true //  doesn't affect things?
			
			hudWindow.contentMaxSize = screenRect.size
			
			// ---- snip -----
			
			// add soft blur effect behind text ?? - tried this before succeeding with NSVisualEffectView
			//		if let bfilter = CIFilter(name: "CIGaussianBlur", withInputParameters: [kCIInputRadiusKey : 13]) {
			//			self.hudView.backgroundFilters.append(bfilter) }
			
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
			if let bfilter = CIFilter(name: "CIMotionBlur",
									  parameters: [kCIInputRadiusKey : 0])
			{
				
				hudView_CIMotionBlur = bfilter
				self.hudView.contentFilters.append(bfilter)
				
			}
			
		}
		
	}
	
	/// Updates the UI with new parameters after `__create()` has been called.
	fileprivate func __modify(
		msg: String,
		position: HUD.Style.Position = .center,
		size: HUD.Style.Size = .medium,
		shade: HUD.Style.Shade = .dark,
		bordered: Bool = false
	) throws {
		
		try autoreleasepool {
			
			// grab first screen
			// (not .main) because .main will reference focused screen if user has "Displays have separate Spaces" enabled in System Preferences -> Mission Control
			guard let nsScreenFirst = NSScreen.screens.first else {
				throw HUD.HUDError.internalInconsistency("Can't get reference to main screen.")
			}
			
			// determine maximum size for notification
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
			
			if bordered {
				switch shade {
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
				hudTextField.setFrameSize(NSSize(width: screenRect.width, height: hudTextField.frame.width))
			}
			if hudTextField.frame.height > screenRect.height {
				hudTextField.setFrameSize(NSSize(width: hudTextField.frame.width, height: screenRect.height))
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
			hudWindow.setFrame(hudWindow.constrainFrameRect(hudWindow.frame, to: nsScreenFirst), display: true)
			
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
		
	}
	
	
	/// Shows it on screen.
	fileprivate func __show(
		stickyTime: TimeInterval = 3,
		fadeOut: HUD.Style.Fade = .defaultDuration
	) {
		
		autoreleasepool {
			
			// show notification
			hudWindow.orderFront(self)
			
			// remain on screen for specified time period; schedule the fade out
			DispatchQueue.main.asyncAfterDelta(stickyTime) { [weak self] in
				
				autoreleasepool {
					try? self?.dismiss(fadeOut)
				}
				
			}
			
			// animate notification appearing
			hudWindow.alphaValue = 0
			NSAnimationContext.runAnimationGroup(
				{ [weak self] context in
					autoreleasepool {
						context.duration = 0.05
						self?.hudWindow.animator().alphaValue = 1
					}
				}, completionHandler: {
					// empty
				}
			)
			
		}
		
	}
	
}

// MARK: - Protocol Adoptions

extension HUD.Notification: Equatable {
	
	static func == (lhs: HUD.Notification, rhs: HUD.Notification) -> Bool {
		
		lhs.uuid == rhs.uuid
		
	}
	
}
