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
	
	/// HUD popup alert singleton class.
	internal class Controller {
		
		/// Shared HUD popup alert dispatcher.
		static let shared = Controller() // singleton
		
		internal var alerts: [Alert] =
			(1...5)
			.reduce(into: []) {
				$0.append(Alert())
				_ = $1
			}
		
		internal func addNewAlert() -> Alert {
			
			let newAlert = Alert()
			alerts.append(newAlert)
			return newAlert
			
		}
		
		internal func getFreeAlert() -> Alert {
			
			precondition(alerts.count > 0)
			
			if let firstFree = alerts
				.first(where: { !$0.inUse })
			{
				return firstFree
			}
			
			// failsafe: cap max number of alerts
			if alerts.count > 100 {
				return alerts.last!
			}
			
			// add new object and return it
			return addNewAlert()
			
		}
		
		private init() {
			
		}
		
		/// Number of active HID alerts.
		public var count: Int {
			
			alerts.reduce(0) {
				$0 + ($1.inUse ? 1 : 0)
			}
			
		}
		
		/// Trigger a new HID alert being shown on-screen.
		internal func newHUDAlert(_ msg: String,
								  style: Style)
		{
			
			autoreleasepool {
				
				let alert = self.getFreeAlert()
				
				// trigger alert
				try? alert.show(
					msg: msg,
					style: style
				)
				
			}
			
		}
		
	}
	
}
