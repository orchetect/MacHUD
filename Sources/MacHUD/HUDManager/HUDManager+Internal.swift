//
//  HUDManager+Internal.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation

extension HUDManager {
    static let maxConcurrentAlerts: Int = 10
    
    func prewarmAlerts(style: (some HUDStyle).Type, count: Int = 2) async {
        let id = style.id
        let currentCount = alerts[id]?.count ?? 0
        let count = (count - currentCount).clamped(to: 0 ... Self.maxConcurrentAlerts)
        do {
            for _ in 0 ..< count {
                _ = try await addNewAlert(style: style)
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
    
    func alerts<S: HUDStyle>(style: S.Type) async -> [Alert<S>]? {
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
    
    func reusableAlert<S: HUDStyle>(style: S.Type, for content: S.AlertContent) async throws -> Alert<S> {
        // return first reusable alert that is compatible with the content
        if let alertPool = await alerts(style: style) {
            for alert in alertPool {
                if await alert.isReusable(for: content) { return alert }
            }
            
            // failsafe: cap max number of alerts
            if alertPool.count > Self.maxConcurrentAlerts,
               let lastAlert = alertPool.last
            {
                return lastAlert
            }
        }
        
        // add new alert and return it
        return try await addNewAlert(style: style)
    }
    
    /// Trigger a new HID alert being shown on-screen.
    func newHUDAlert<S: HUDStyle>(
        style: S,
        content: S.AlertContent,
        waitForDismiss: Bool
    ) async {
        do {
            let alert = try await reusableAlert(style: S.self, for: content)
            try await alert.show(content: content, style: style)
            if waitForDismiss {
                await alert.wait(for: .inactive, timeout: 60.0)
            }
        } catch {
            logger.debug("Error displaying HUD alert: \(error.localizedDescription)")
        }
    }
}

#endif
