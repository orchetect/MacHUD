import XCTest
import AppKit // not needed?
@testable import HUDKit
import OTCore
import OTCoreTestingXCTest

final class HUDKitTests: XCTestCase {
	
	override func setUp() {
		Log.setup(enabled: true,
				  defaultLog: nil,
				  defaultSubsystem: nil,
				  useEmoji: .all)
	}
	
	func testDummy() {
		
		HUD.displayAlert("Test")
		
		XCTWait(sec: 5)
		
		print("Done")
		
	}
	
}
