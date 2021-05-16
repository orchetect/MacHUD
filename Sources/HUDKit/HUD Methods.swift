//
//  HUD Methods.swift
//  HUDKit
//
//  Created by Steffan Andrews on 2016-06-26.
//  Copyright © 2016 Steffan Andrews. All rights reserved.
//

extension HUD {
	
	/// Display a HUD alert on the screen.
	public static func displayAlert(_ message: String) {
		
		Controller.shared.newHUDAlert(
			message,
			stickyTime: 1.2,
			position: .bottom,
			size: .large,
			style: .dark,
			bordered: false,
			fadeOut: .withDuration(0.8)
		)
		
	}
	
	/// Display a HUD alert on the screen.
	public static func displayAlertEmoji(_ message: String) {
		
		Controller.shared.newHUDAlert(
			message,
			stickyTime: 1.2,
			position: .bottom,
			size: .superLarge,
			style: .dark,
			bordered: false,
			fadeOut: .withDuration(0.8)
		)
		
	}
	
}
