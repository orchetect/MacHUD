//
//  HUDAlertProtocol.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import AppKit
import Foundation

/// Internal HUD alert protocol enabling type erasure of typed ``Alert`` objects.
protocol HUDAlertProtocol: AnyObject, Sendable {
    @HUDManager
    var phase: HUDManager.AlertPhase { get set }
    
    @MainActor
    var window: NSWindow? { get set }
}

#endif
