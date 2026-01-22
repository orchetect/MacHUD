//
//  HUDManager Alert+Lifecycle.swift
//  swift-hud • https://github.com/orchetect/swift-hud
//

import AppKit

extension HUDManager.Alert {
    @MainActor
    func setup() async {
        guard await !isSetup else { return }
        
        self.hudWindow = NSWindow(
            contentRect: NSMakeRect(0, 0, 500, 160),
            styleMask: .borderless,
            backing: .buffered,
            defer: true
        )
        
        self.hudView = hudWindow.contentView
        
        let newTextField = NSTextField()
        self.hudTextField = newTextField
        hudView.addSubview(hudTextField)
        
        hudWindow.contentView? = hudView
        
        do {
            try _create()
            
            Task { @HUDManager in
                isSetup = true
            }
            
            logger.debug("Created HUD alert window.")
        } catch {
            logger.debug("Error creating HUD alert window: \(error.localizedDescription)")
        }
    }
}
