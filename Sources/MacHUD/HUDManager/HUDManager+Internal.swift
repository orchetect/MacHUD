//
//  HUDManager+Internal.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation

extension HUDManager {
    static let maxConcurrentAlerts: Int = 10
    
    func prewarmAlerts(hudStyle: (some HUDStyle).Type, count: Int = 2) async {
        do {
            for _ in 0 ..< count.clamped(to: 0 ... Self.maxConcurrentAlerts) {
                _ = try await addNewAlert(style: hudStyle)
            }
        } catch {
            logger.debug("Error warming the HUDManager: \(error.localizedDescription)")
        }
    }
    
    @discardableResult
    func addNewAlert<S: HUDStyle>(style: S.Type) async throws -> Alert<S> {
        let id = style.id
        if alerts[id] == nil { alerts[id] = [] }
        let newAlert = try await Alert<S>(style: S())
        alerts[id]?.append(newAlert)
        return newAlert
    }
    
    func getAlerts<S: HUDStyle>(style: S.Type) async -> [Alert<S>]? {
        let id = style.id
        guard let alertPool = alerts[id] else { return nil }
        let typedAlertPool: [Alert<S>] = alertPool.reduce(into: []) { base, anyAlert in
            guard let typedAlert = anyAlert as? Alert<S> else {
                assertionFailure("Found unexpected reusable alert object for \(id.hudStyle).")
                return
            }
            base.append(typedAlert)
        }
        return typedAlertPool
    }
    
    func getFreeAlert<S: HUDStyle>(style: S.Type) async throws -> Alert<S> {
        // return first reusable alert that is inactive, if any
        if let alertPool = await getAlerts(style: style) {
            for alert in alertPool {
                if await !alert.isInUse { return alert }
            }
            
            // failsafe: cap max number of alerts
            if alertPool.count > Self.maxConcurrentAlerts, let lastAlert = alertPool.last {
                return lastAlert
            }
        }
        
        // add new alert and return it
        return try await addNewAlert(style: style)
    }
    
    /// Trigger a new HID alert being shown on-screen.
    func newHUDAlert<S: HUDStyle>(
        style: S,
        content: S.AlertContent
    ) async {
        do {
            let alert = try await getFreeAlert(style: S.self)
            try await alert.show(content: content, style: style)
        } catch {
            logger.debug("Error displaying HUD alert: \(error.localizedDescription)")
        }
    }
}

#endif
