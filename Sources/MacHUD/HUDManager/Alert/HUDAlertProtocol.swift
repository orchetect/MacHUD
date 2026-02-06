//
//  AlertProtocol.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation
import AppKit

/// Internal HUD alert protocol enabling type erasure of typed ``Alert`` objects.
protocol HUDAlertProtocol: AnyObject, Sendable {
    @HUDManager var isInUse: Bool { get set }
    @MainActor var window: NSWindow? { get set }
}

#endif
