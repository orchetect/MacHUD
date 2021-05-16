//
//  HUD Controller.swift
//  HUDKit
//
//  Created by Steffan Andrews on 6/26/2016
//  Copyright © 2016 Steffan Andrews. All rights reserved.
//

import AppKit
@_implementationOnly import CoreImage
@_implementationOnly import OTCore

extension HUD {
	
	/// HUD popup notification singleton class.
	internal class Controller {
		
		/// Shared HUD popup notification dispatcher.
		static let shared = Controller() // singleton
		
//		/// Set to desired behavior when overlapping HID notifications occur
//		static var overlapBehavior: OverlapBehavior = .replaceLast
		
		internal var notifications: [Notification] = []
		
		internal var perpetualInstanceCounter: Int = 0
		
		private init() {
			
		}
		
		/// Number of active HID notifications
		public var count: Int {
			
			notifications.count
			
		}
		
		/// This is the method to call to trigger a new HID alert notification.
		/// Overlap behavior is determined by `overlapBehavior` property of singleton class.
		internal func newHUDAlert(_ msg: String,
								  stickyTime: TimeInterval = 3,
								  position: Position = .center,
								  size: Size = .medium,
								  style: Style = .dark,
								  bordered: Bool = false,
								  fadeOut: Fade = .defaultDuration)
		{
			
			DispatchQueue.main.async { // we need to do UI stuff on the main thread
				
				// not sure if this truly helps but it might prevent runaway RAM footprints
				autoreleasepool {
					
					let notification = Notification()
					
					// add to top of notifications array
					self.notifications.insert(notification, at: 0)
					
					// trigger notification
					try? notification.createAndShow(
						msg: msg,
						stickyTime: stickyTime,
						position: position,
						size: size,
						style: style,
						bordered: bordered,
						fadeOut: fadeOut
					)
					
				}
				
			}
			
		}
		
	}
	
}

extension HUD {
	
	enum Position: Int {
		
		case top, bottom, center
		
	}
	
}

extension HUD {
	
	enum Size: Int {
		
		case small, medium, large, superLarge
		
	}
	
}

extension HUD {
	
	enum Style: Int {
		
		case light, mediumLight, dark, ultraDark
		
	}
	
}

extension HUD {
	
	enum Fade: Equatable {
		
		case defaultDuration
		case withDuration(Double)
		case noFade
		
		static func == (lhs: Self, rhs: Self) -> Bool {
			
			switch (lhs, rhs) {
			case (.defaultDuration, .defaultDuration):
				return true
				
			case (.withDuration(let a), .withDuration(let b)) where a == b:
				return true
				
			case (.noFade, .noFade):
				return true
				
			default:
				return false
			}
			
		}
		
	}
	
}

extension HUD {
	
	/// Setting determining behavior of overlapping HID notifications
	enum OverlapBehavior: Int {
		
		case replaceLast, stack
		
	}
	
}
