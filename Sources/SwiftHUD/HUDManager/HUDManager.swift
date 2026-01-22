//
//  HUDManager.swift
//  swift-hud • https://github.com/orchetect/swift-hud
//

import Foundation

@globalActor public actor HUDManager {
    /// Shared singleton instance.
    public static let shared = HUDManager()
    
    /// Pool of alerts.
    var alerts: [Alert] = []
    
    private init() { }
}
