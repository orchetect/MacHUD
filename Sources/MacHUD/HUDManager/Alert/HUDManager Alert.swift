//
//  HUDManager Alert.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import AppKit
import SwiftUI

extension HUDManager {
    /// Represents a reusable HUD alert object which can be shown and hidden.
    final class Alert<Style: HUDStyle>: HUDAlertProtocol, Sendable {
        @HUDManager var style: Style
        
        // MARK: - State
        
        @HUDManager var isInUse = false
		
        // MARK: - UI
		
        @MainActor var window: NSWindow?
		
        // MARK: - Init
		
        init(style: Style) async throws {
            self.style = style
            _ = try await Task { @MainActor in
                window = try await windowFactory()
            }.value
            
            logger.debug("Created new reusable \(type(of: style)) HUD alert object.")
        }
		
        deinit {
            logger.debug("\(type(of: style)) HUD alert object instance deinit")
        }
    }
}

#endif
