//
//  HUDManager Alert.swift
//  swift-hud • https://github.com/orchetect/swift-hud
//

import AppKit
import SwiftUI

extension HUDManager {
    /// Represents a HUD alert object which can be shown and hidden.
    final class Alert: Sendable {
        @HUDManager var isInUse = false
		
        // MARK: - UI
		
        @MainActor var hudWindow: NSWindow?
        @MainActor weak var hudView: NSView?
        @MainActor weak var hudViewVisualEffectView: NSVisualEffectView?
        @MainActor weak var hudViewCIMotionBlur: CIFilter? // not currently being used
        @MainActor weak var contentView: NSHostingView<HUDManager.Alert.ContentView>?
		
        // MARK: - Init
		
        init() async throws {
            _ = try await Task { @MainActor in
                (hudWindow, hudView, hudViewVisualEffectView, hudViewCIMotionBlur, contentView) = try Self.windowFactory()
            }.value
            
            logger.debug("Created new reusable HUD alert object.")
        }
		
        deinit {
            logger.debug("HUD alert object instance deinit")
        }
    }
}
