//
//  HUDManager Methods.swift
//  swift-hud • https://github.com/orchetect/swift-hud
//

import Foundation

// MARK: - Public

extension HUDManager {
    /// Pre-warms the HUD manager by populating the internal alert window pool with a few HUD alert windows. (Optional)
    ///
    /// This will reduce the amount of time required before the application's first alert window shows the first time
    /// an alert is requested to be shown.
    ///
    /// Typically this called at application launch.
    public func warm() async {
        guard alerts.isEmpty else { return }
        for _ in 0 ..< 5 {
            await addNewAlert()
        }
    }
    
    /// Display a HUD alert on the screen.
    nonisolated
    public func displayAlert(
        _ message: String,
        style: HUDStyle = .currentPlatform
    ) {
        Task {
            await newHUDAlert(message, style: style)
        }
    }
    
    /// Returns the number of active HUD alerts on-screen.
    @HUDManager
    public var activeCount: Int {
        get async {
            await alerts.reduce(0) {
                $0 + ($1.isInUse ? 1 : 0)
            }
        }
    }
}

// MARK: - Internal

extension HUDManager {
    @discardableResult
    func addNewAlert() async -> Alert {
        let newAlert = await Alert()
        alerts.append(newAlert)
        return newAlert
    }
    
    func getFreeAlert() async -> Alert {
        // return first reusable alert that is inactive, if any
        for alert in alerts {
            if await !alert.isInUse { return alert }
        }
        
        // failsafe: cap max number of alerts
        if alerts.count > 100, let lastAlert = alerts.last {
            return lastAlert
        }
        
        // add new alert and return it
        return await addNewAlert()
    }
    
    /// Trigger a new HID alert being shown on-screen.
    func newHUDAlert(
        _ msg: String,
        style: HUDStyle
    ) async {
        let alert = await getFreeAlert()
        
        // trigger alert
        do {
            try await alert.show(msg: msg, style: style)
        } catch {
            logger.debug("Error displaying HUD alert: \(error.localizedDescription)")
        }
    }
}
