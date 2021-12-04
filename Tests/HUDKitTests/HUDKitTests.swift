//
//  HUDKitTests.swift
//  HUDKit • https://github.com/orchetect/HUDKit
//

import XCTest
import AppKit // not needed?
@testable import HUDKit
import OTCore

final class HUDKitTests: XCTestCase {
	
	override func setUp() { }
	
	func testStyle() {
		
		// default - automatic
		
		_ = HUD.Style()
		
		// presets
		
		_ = HUD.Style(.automatic)
		_ = HUD.Style(.macOS_10_15)
		_ = HUD.Style(.macOS_11_0)
		
		// custom
		
		_ = HUD.Style(
			stickyTime: 3
		)
		
		_ = HUD.Style(
			stickyTime: 3,
			position: .bottom,
			size: .medium,
			shade: .mediumLight,
			bordered: false,
			fadeOut: .defaultDuration
		)
		
	}
	
	func testHUD() {
		
		HUD.displayAlert("Test")
		
        sleep(2)
		
		print("Done")
		
	}
	
}
