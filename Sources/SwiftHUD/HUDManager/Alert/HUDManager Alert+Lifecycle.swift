//
//  HUDManager Alert+Lifecycle.swift
//  swift-hud • https://github.com/orchetect/swift-hud
//

import AppKit

extension HUDManager.Alert {
    @MainActor
    func setup() async throws {
        guard await !isSetup else { return }
        
        (hudWindow, hudView, hudViewVisualEffectView, hudViewCIMotionBlur, hudTextField) = try Self.windowFactory()
        
        Task { @HUDManager in
            isSetup = true
        }
        
        logger.debug("Created new reusable HUD alert object.")
    }
}
