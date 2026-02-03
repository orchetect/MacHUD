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
    public nonisolated func displayAlert(
        _ content: HUDAlertContent
    ) {
        Task {
            await newHUDAlert(content: content, style: .currentPlatform())
        }
    }
    
    /// Display a HUD alert on the screen asynchronously using the specified style.
    public nonisolated func displayAlert(
        _ content: HUDAlertContent,
        style: some HUDStyle
    ) {
        Task {
            await newHUDAlert(content: content, style: AnyHUDStyle(style))
        }
    }
    
    /// Display a HUD alert on the screen asynchronously using the specified style.
    public nonisolated func displayAlert(
        _ content: HUDAlertContent,
        style: AnyHUDStyle
    ) {
        Task {
            await newHUDAlert(content: content, style: style)
        }
    }
}

extension HUDManager {
    /// Display a HUD alert on the screen synchronously using the default style for the current platform.
    /// This method waits until the alert is fully dismissed before returning.
    public nonisolated func displayAlertAndWaitUntilDismissed(
        _ content: HUDAlertContent
    ) async {
        await newHUDAlert(content: content, style: .currentPlatform())
    }
    
    /// Display a HUD alert on the screen synchronously using the specified style.
    /// This method waits until the alert is fully dismissed before returning.
    public nonisolated func displayAlertAndWaitUntilDismissed(
        _ content: HUDAlertContent,
        style: some HUDStyle
    ) async {
        await newHUDAlert(content: content, style: AnyHUDStyle(style))
    }
    
    /// Display a HUD alert on the screen synchronously using the specified style.
    /// This method waits until the alert is fully dismissed before returning.
    public nonisolated func displayAlertAndWaitUntilDismissed(
        _ content: HUDAlertContent,
        style: AnyHUDStyle
    ) async {
        await newHUDAlert(content: content, style: style)
    }
}

extension HUDManager {
    /// Pre-warms the HUD manager by populating the internal reusable alert window pool with a handful of
    /// HUD alert windows. (Optional)
    ///
    /// This will reduce the amount of preparation time required before the first alert shows.
    ///
    /// Typically this called at application launch.
    public func prewarm(customHUDStyles: [any HUDStyle.Type] = [], count: Int = 2) async {
        guard alerts.isEmpty else { return }
        
        do {
            let hudStyles = AnyHUDStyle.hudStyleTypes(customHUDStyles: customHUDStyles)
            for hudStyle in hudStyles {
                for _ in 0 ..< count.clamped(to: 0 ... Self.maxConcurrentAlerts) {
                    _ = try await addNewAlert(styleID: hudStyle.id)
                }
            }
        } catch {
            logger.debug("Error warming the HUDManager: \(error.localizedDescription)")
        }
    }
    
    /// Returns the number of active HUD alerts on-screen.
    @HUDManager
    public var activeCount: Int {
        get async {
            await alerts.values.flatMap(\.self).reduce(0) {
                $0 + ($1.isInUse ? 1 : 0)
            }
        }
    }
}

#endif
