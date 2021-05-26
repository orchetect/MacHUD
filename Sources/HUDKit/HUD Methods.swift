//
//  HUD Methods.swift
//  HUDKit
//
//  Created by Steffan Andrews on 2016-06-26.
//  Copyright © 2016 Steffan Andrews. All rights reserved.
//

import Foundation

extension HUD {
	
	/// Display a HUD alert on the screen.
	public static func displayAlert(
		_ message: String,
		style: Style = Style()
	) {
		
		// we need to do UI stuff on the main thread
		DispatchQueue.main.async {
			
			autoreleasepool {
				
				Controller.shared.newHUDAlert(
					message,
					style: style
				)
				
			}
			
		}
		
	}
	
}
