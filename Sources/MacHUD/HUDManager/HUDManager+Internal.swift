//
//  HUDManager+Internal.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation

extension HUDManager {
    static let maxConcurrentAlerts: Int = 10
    
    @discardableResult
    func addNewAlert(style: AnyHUDStyle) async throws -> Alert {
        let id = type(of: style.base).id
        return try await addNewAlert(styleID: id)
    }
    
    @discardableResult
    func addNewAlert(styleID id: HUDStyleID) async throws -> Alert {
        if alerts[id] == nil { alerts[id] = [] }
        
        let style = AnyHUDStyle(id.hudStyle.default())
        let newAlert = try await Alert(style: style)
        alerts[id]?.append(newAlert)
        return newAlert
    }
    
    func getFreeAlert(style: AnyHUDStyle) async throws -> Alert {
        let id = type(of: style.base).id
        return try await getFreeAlert(styleID: id)
    }
    
    func getFreeAlert(styleID id: HUDStyleID) async throws -> Alert {
        // return first reusable alert that is inactive, if any
        if let alertPool = alerts[id] {
            for alert in alertPool {
                if await !alert.isInUse { return alert }
            }
            
            // failsafe: cap max number of alerts
            if alertPool.count > Self.maxConcurrentAlerts, let lastAlert = alertPool.last {
                return lastAlert
            }
        }
        
        // add new alert and return it
        return try await addNewAlert(styleID: id)
    }
    
    /// Trigger a new HID alert being shown on-screen.
    func newHUDAlert(
        content: HUDAlertContent,
        style: AnyHUDStyle
    ) async {
        do {
            let alert = try await getFreeAlert(style: style)
            try await alert.show(content: content, style: style)
        } catch {
            logger.debug("Error displaying HUD alert: \(error.localizedDescription)")
        }
    }
}

#endif
