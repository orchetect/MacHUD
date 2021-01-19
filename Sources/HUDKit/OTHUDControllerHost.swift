//
//  OTHUDControllerHost.swift
//  HUDKit
//
//  Created by AntScript on 5/18/16.
//  Copyright © 2016 AApp.Space. All rights reserved.
//
//  Modified by Steffan Andrews on 6/26/2016
//

import AppKit
@_implementationOnly import CoreImage
@_implementationOnly import OTCore

/// HUD popup notification singleton class.
public class OTHUDControllerHost {
	
	/// Shared HUD popup notification dispatcher.
	public static let shared = OTHUDControllerHost() // singleton

	/// Set to desired behavior when overlapping HID notifications occur
	static var hidOverlapBehavior: hidManagerOverlapBehavior = .replaceLast
	
	internal var OTHUDNotifications = [OTHUDNotification]() // array of weak references
	internal var perpetualInstanceCounter: Int = 0
	
	private init() { }
	
	/// Number of active HID notifications
	public var count: Int {
		get {
			return OTHUDNotifications.count
		}
		set {
			fatalError("OTHUDControllerHost.count has no setter. It is get-only.")
		}
	}
	
	/// This is the method to call to trigger a new HID alert notification.
	/// Overlap behavior is determined by `hidOverlapBehavior` property of singleton class.
	func showNewHUDAlert(_ msg: String,
	                     stickyTime: TimeInterval = 3,
	                     position: OTHUDPosition = .center,
	                     size: OTHUDSize = .medium,
	                     style: OTHUDStyle = .dark,
	                     bordered: Bool = false,
	                     fadeOut: OTHUDFade = .defaultDuration) {
	
		// check for any existing notifications in the manager array
		
		// add notification instance and it will self-init
		autoreleasepool { // not sure if this truly helps but it might prevent runaway RAM footprints
	
			var notification: OTHUDNotification?
	
			DispatchQueue.main.async { // we need to do UI stuff on the main thread
				
				notification = OTHUDNotification()
				
				guard let notification = notification else {
					Log.error("OTHUD: showNewHUDAlert(...) Error: Failed to create OTHUDNotification object.")
					return
				}
				
				// add to notifications array
				self.OTHUDNotifications.insert(notification, at: 0)
				
				// trigger notification
				notification.showHUD(msg: msg,
									 stickyTime: stickyTime,
									 position: position,
									 size: size,
									 style: style,
									 bordered: bordered,
									 fadeOut: fadeOut)
				
			}
	
		}
		
	}
	
}

enum OTHUDPosition: Int {
	
	case top, bottom, center
	
}

enum OTHUDSize: Int {
	
	case small, medium, large, superLarge
	
}

enum OTHUDStyle: Int {
	
	case light, mediumLight, dark, ultraDark
	
}

enum OTHUDFade: Equatable {
	
	case defaultDuration
	case withDuration(Double)
	case noFade
	
}

func ==(a: OTHUDFade, b: OTHUDFade) -> Bool {
	
	switch (a, b) {
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

/// Setting determining behavior of overlapping HID notifications
enum hidManagerOverlapBehavior: Int {
	
	case replaceLast, stack
	
}
