//
//  HUDManager.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation

@globalActor public actor HUDManager {
    /// Shared singleton instance.
    public static let shared = HUDManager()
    
    /// Pool of reusable alert windows.
    var alerts: [HUDStyleID: [any HUDAlertProtocol]] = [:]
    
    private init() { }
}

#endif
