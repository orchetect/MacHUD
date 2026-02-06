//
//  HUDManager Alert+Context.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import AppKit
import SwiftUI

extension HUDManager.Alert {
    @MainActor
    func context() throws -> HUDWindowContext {
        guard let window else {
            throw HUDError.internalInconsistency("Could not generate HUD alert window context.")
        }
        
        return try Self.context(window: window)
    }
    
    @MainActor
    static func context(window: NSWindow) throws -> HUDWindowContext {
        let screen = try NSScreen.alertScreen
        
        // since we don't have SwiftUI environment, we have to get system color scheme manually
        return HUDWindowContext(
            colorScheme: systemColorScheme(),
            window: window,
            screen: screen
        )
    }
    
    @MainActor
    func getHostingView() -> NSHostingView<BaseContentView>? {
        window?.contentView?.subviews
            .compactMap { $0 as? NSHostingView<BaseContentView> }
            .first
    }
}

#endif
