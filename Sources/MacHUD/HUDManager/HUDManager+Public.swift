//
//  HUDManager+Public.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation

// MARK: - Public

extension HUDManager {
    /// Display a HUD alert on the screen asynchronously using the default style for the current platform.
    public func displayAlert(
        _ content: DefaultHUDStyle.AlertContent
    ) async {
        await displayAlert(style: .platformDefault(), content: content)
    }
    
    /// Display a HUD alert on the screen asynchronously using the specified style.
    public func displayAlert<S: HUDStyle>(
        style: S,
        content: S.AlertContent
    ) async {
        await displayAlert(style: style, content: content, waitForDismiss: false)
    }
}

extension HUDManager {
    /// Display a HUD alert on the screen synchronously using the default style for the current platform.
    /// This method waits until the alert is fully dismissed before returning.
    public func displayAlertAndWaitUntilDismissed(
        _ content: DefaultHUDStyle.AlertContent
    ) async {
        await displayAlertAndWaitUntilDismissed(style: .platformDefault(), content: content)
    }
    
    /// Display a HUD alert on the screen synchronously using the specified style.
    /// This method waits until the alert is fully dismissed before returning.
    public func displayAlertAndWaitUntilDismissed<S: HUDStyle>(
        style: S,
        content: S.AlertContent
    ) async {
        await displayAlert(style: style, content: content, waitForDismiss: true)
    }
}

extension HUDManager {
    /// Pre-warms the HUD manager by populating the internal reusable alert window pool with a handful of
    /// HUD alert windows. (Optional)
    ///
    /// This will reduce the amount of preparation time required before the first alert shows.
    ///
    /// Typically this called at application launch.
    public func prewarm<each S: HUDStyle>(
        customHUDStyles: repeat (each S).Type,
        count: Int = 2
    ) async {
        // internal styles
        await prewarmAlerts(style: ProminentHUDStyle.self, count: count)
        if #available(macOS 26.0, *) {
            await prewarmAlerts(style: MenuPopoverHUDStyle.self, count: count)
        }
        
        // custom styles
        for hudStyle in repeat each customHUDStyles {
            await prewarmAlerts(style: hudStyle, count: count)
        }
    }
    
    /// Synchronously waits for all HUD alerts to dismiss from the screen.
    @concurrent nonisolated
    public func waitForAlertsToDismiss(timeout: TimeInterval? = nil) async throws {
        let timeIn = Date()
        while !Task.isCancelled {
            guard await activeCount > 0 else {
                logger.debug("No active on-screen HUD alerts to wait for. Returning immediately.")
                return
            }
            try await Task.sleep(seconds: 0.1)
            if let timeout {
                guard Date().timeIntervalSince(timeIn) < timeout else { throw HUDError.timeout }
            }
        }
    }
    
    /// Returns the number of active HUD alerts on-screen.
    public var activeCount: Int {
        get async {
            let ids = alerts.keys
            var count = 0
            for id in ids {
                for alert in alerts[id] ?? [] {
                    let phase = await alert.phase
                    if phase != .inactive { count += 1 }
                }
            }
            return count
        }
    }
}

#endif
