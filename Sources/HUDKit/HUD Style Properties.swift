//
//  HUD Style Properties.swift
//  HUDKit
//
//  Created by Steffan Andrews on 2021-05-25.
//  Copyright © 2021 Steffan Andrews. All rights reserved.
//

import Foundation

extension HUD.Style {
	
	public enum Position: Int, CaseIterable {
		
		case top, bottom, center
		
	}
	
}

extension HUD.Style {
	
	public enum Size: Int, CaseIterable {
		
		case small, medium, large, superLarge
		
	}
	
}

extension HUD.Style {
	
	public enum Shade: Int, CaseIterable {
		
		case light, mediumLight, dark, ultraDark
		
	}
	
}

extension HUD.Style {
	
	public enum Fade: Equatable, Hashable {
		
		case defaultDuration
		case withDuration(TimeInterval)
		case noFade
		
		public static func == (lhs: Self, rhs: Self) -> Bool {
			
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
