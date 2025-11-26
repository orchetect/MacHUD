//
//  HUD Manager.swift
//  swift-hud • https://github.com/orchetect/swift-hud
//

import AppKit
internal import CoreImage
internal import SwiftExtensions

extension HUD {
    /// HUD popup alert singleton class.
    @MainActor final class Manager {
        /// Shared HUD popup alert dispatcher.
        static let shared = Manager() // singleton
		
        internal var alerts: [Alert] =
            (1 ... 5)
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
            precondition(!alerts.isEmpty)
			
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
		
        private init() { }
		
        /// Number of active HID alerts.
        public var count: Int {
            alerts.reduce(0) {
                $0 + ($1.inUse ? 1 : 0)
            }
        }
		
        /// Trigger a new HID alert being shown on-screen.
        internal func newHUDAlert(
            _ msg: String,
            style: Style
        ) {
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
