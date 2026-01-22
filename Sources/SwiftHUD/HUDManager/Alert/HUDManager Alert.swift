//
//  HUDManager Alert.swift
//  swift-hud • https://github.com/orchetect/swift-hud
//

import AppKit

extension HUDManager {
    /// Represents a HUD alert object which can be shown and hidden.
    final class Alert: Sendable {
        // nonisolated let id = UUID()
		
        @HUDManager var isSetup = false
        @HUDManager var isInUse = false
		
        // MARK: - UI
		
        @MainActor var hudWindow: NSWindow!
		
        @MainActor weak var hudView: NSView?
        @MainActor weak var hudView_VisualEffectView: NSVisualEffectView?
        @MainActor weak var hudView_CIMotionBlur: CIFilter?
		
        @MainActor weak var hudTextField: NSTextField!
		
        // MARK: - Init
		
        init() async throws {
            try await setup()
        }
		
        deinit {
            logger.debug("HUD Alert instance deinit")
        }
    }
}
