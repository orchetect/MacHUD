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
    final class Alert: Sendable {
        @HUDManager var isInUse = false
		
        // MARK: - UI
		
        @MainActor var window: NSWindow?
        @MainActor weak var reusableView: NSHostingView<AlertBaseContentView>?
		
        // MARK: - Init
		
        init(style: AnyHUDStyle) async throws {
            _ = try await Task { @MainActor in
                (window, reusableView) = try Self.windowFactory(style: style)
            }.value
            
            logger.debug("Created new reusable HUD alert object.")
        }
		
        deinit {
            logger.debug("HUD alert object instance deinit")
        }
    }
}

#endif
