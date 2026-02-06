//
//  DefaultHUDStyle+Window.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation
import SwiftUI

extension DefaultHUDStyle {
    public func windowStyleMask() -> NSWindow.StyleMask {
        if #available(macOS 26.0, *) {
            MenuPopoverHUDStyle().windowStyleMask()
        } else {
            ProminentHUDStyle().windowStyleMask()
        }
    }
    
    @MainActor
    public func setupWindow(context: HUDWindowContext) {
        if #available(macOS 26.0, *) {
            MenuPopoverHUDStyle().setupWindow(context: context)
        } else {
            ProminentHUDStyle().setupWindow(context: context)
        }
    }
    
    @MainActor
    public func updateWindow(context: HUDWindowContext) {
        if #available(macOS 26.0, *) {
            MenuPopoverHUDStyle().updateWindow(context: context)
        } else {
            ProminentHUDStyle().updateWindow(context: context)
        }
    }
}

#endif
