//
//  DefaultHUDStyle+Window.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation
import SwiftUI

extension DefaultHUDStyle {
    public func windowStyleMask() -> NSWindow.StyleMask {
        if #available(macOS 26.0, *) {
            convertedToMenuPopoverHUDStyle().windowStyleMask()
        } else {
            convertedToProminentHUDStyle().windowStyleMask()
        }
    }

    @MainActor
    public func windowPhase(phase: HUDWindowPhase, context: HUDWindowContext) {
        if #available(macOS 26.0, *) {
            convertedToMenuPopoverHUDStyle().windowPhase(phase: phase, context: context)
        } else {
            convertedToProminentHUDStyle().windowPhase(phase: phase, context: context)
        }
    }
}

#endif
