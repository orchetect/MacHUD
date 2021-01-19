//
//  OTHUD Convenience Methods.swift
//  HUDKit
//
//  Created by Steffan Andrews on 2016-06-26.
//  Copyright © 2016 Steffan Andrews. All rights reserved.
//

/// Display a HUD alert on the screen.
public func hudDisplayAlert(_ message: String) {
	
	OTHUDControllerHost.shared.showNewHUDAlert(message,
											   stickyTime: 1.2,
											   position: .bottom,
											   size: .large,
											   style: .dark,
											   bordered: false,
											   fadeOut: .withDuration(0.8))
	
}

/// Display a HUD alert on the screen.
public func hudDisplayAlertEmoji(_ message: String) {
	
	OTHUDControllerHost.shared.showNewHUDAlert(message,
											   stickyTime: 1.2,
											   position: .bottom,
											   size: .superLarge,
											   style: .dark,
											   bordered: false,
											   fadeOut: .withDuration(0.8))
	
}
