//
//  HUDManager Methods.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
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
        
        do {
            for _ in 0 ..< 5 {
                _ = try await addNewAlert()
            }
        } catch {
            logger.debug("Error warming the HUDManager: \(error.localizedDescription)")
        }
    }
    
    /// Display a HUD alert on the screen asynchronously and returns without waiting for the alert to dismiss.
    public nonisolated func displayAlert(
        _ content: AlertContent,
        style: HUDStyle = .currentPlatform
    ) {
        Task {
            await newHUDAlert(content: content, style: style)
        }
    }
    
    /// Display a HUD alert on the screen and wait until the alert is fully dismissed before returning.
    public nonisolated func displayAlertAndWaitUntilDismissed(
        _ content: AlertContent,
        style: HUDStyle = .currentPlatform
    ) async {
        await newHUDAlert(content: content, style: style)
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
    func addNewAlert() async throws -> Alert {
        let newAlert = try await Alert()
        alerts.append(newAlert)
        return newAlert
    }
    
    func getFreeAlert() async throws -> Alert {
        // return first reusable alert that is inactive, if any
        for alert in alerts {
            if await !alert.isInUse { return alert }
        }
        
        // failsafe: cap max number of alerts
        if alerts.count > 100, let lastAlert = alerts.last {
            return lastAlert
        }
        
        // add new alert and return it
        return try await addNewAlert()
    }
    
    /// Trigger a new HID alert being shown on-screen.
    func newHUDAlert(
        content: AlertContent,
        style: HUDStyle
    ) async {
        do {
            let alert = try await getFreeAlert()
            try await alert.show(content: content, style: style)
        } catch {
            logger.debug("Error displaying HUD alert: \(error.localizedDescription)")
        }
    }
}
