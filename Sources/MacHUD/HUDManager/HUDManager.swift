//
//  HUDManager.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

import Foundation

@globalActor public actor HUDManager {
    /// Shared singleton instance.
    public static let shared = HUDManager()
    
    /// Pool of alerts.
    var alerts: [Alert] = []
    
    private init() { }
}
