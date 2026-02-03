//
//  HUDManager Alert+Context.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//

#if os(macOS)

import AppKit
import SwiftUI

extension HUDManager.Alert {
    @MainActor
    func context() throws -> HUDWindowContext {
        guard let window,
              let reusableView
        else { throw HUDError.internalInconsistency("Could not generate HUD alert window context.") }
        
        return try Self.context(window: window, reusableView: reusableView)
    }
    
    @MainActor
    static func context(
        window: NSWindow,
        reusableView: NSHostingView<HUDManager.AlertBaseContentView>
    ) throws -> HUDWindowContext {
        let screen = try NSScreen.alertScreen
        return HUDWindowContext(window: window, reusableView: reusableView, screen: screen)
    }
}

#endif
