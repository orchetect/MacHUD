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
		
		internal var notifications: [Notification] =
			(1...5)
			.reduce(into: []) {
				$0.append(Notification())
				_ = $1
			}
		
		internal func addNewNotification() -> Notification {
			
			let newNotification = Notification()
			notifications.append(newNotification)
			return newNotification
			
		}
		
		internal func getFreeNotification() -> Notification {
			
			precondition(notifications.count > 0)
			
			if let firstFree = notifications
				.first(where: { !$0.inUse })
			{
				return firstFree
			}
			
			// failsafe: don't allow more than 100 notification objects
			if notifications.count > 100 {
				return notifications.last!
			}
			
			// add new object and return it
			return addNewNotification()
			
		}
		
		private init() {
			
		}
		
		/// Number of active HID notifications
		public var count: Int {
			
			notifications.reduce(0) {
				$0 + ($1.inUse ? 1 : 0)
			}
			
		}
		
		/// This is the method to call to trigger a new HID alert notification.
		internal func newHUDAlert(_ msg: String,
								  stickyTime: TimeInterval = 3,
								  position: Position = .center,
								  size: Size = .medium,
								  style: Style = .dark,
								  bordered: Bool = false,
								  fadeOut: Fade = .defaultDuration)
		{
			
			autoreleasepool {
				
				let notification = self.getFreeNotification()
				
				// trigger notification
				try? notification.show(
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
