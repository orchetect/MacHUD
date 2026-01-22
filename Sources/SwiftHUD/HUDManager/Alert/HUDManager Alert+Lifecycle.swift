//
//  HUDManager Alert+Lifecycle.swift
//  swift-hud • https://github.com/orchetect/swift-hud
//

import AppKit

extension HUDManager.Alert {
    @MainActor
    func setup() async throws {
        guard await !isSetup else { return }
        
        self.hudWindow = NSWindow(
            contentRect: NSMakeRect(0, 0, 500, 160),
            styleMask: .borderless,
            backing: .buffered,
            defer: true
        )
        
        guard let contentView = hudWindow.contentView else {
            throw HUDError.internalInconsistency("Window has no content view.")
        }
        
        self.hudView = contentView
        
        let newTextField = NSTextField()
        self.hudTextField = newTextField
        hudView?.addSubview(hudTextField)
        
        try _create()
        
        Task { @HUDManager in
            isSetup = true
        }
        
        logger.debug("Created new reusable HUD alert object.")
    }
}
