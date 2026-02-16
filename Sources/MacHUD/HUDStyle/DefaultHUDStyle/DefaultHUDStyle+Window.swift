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
            convertedToMenuPopoverHUDStyle().windowStyleMask()
        } else {
            convertedToProminentHUDStyle().windowStyleMask()
        }
    }
    
    @MainActor
    public func setupWindow(context: HUDWindowContext) {
        if #available(macOS 26.0, *) {
            convertedToMenuPopoverHUDStyle().setupWindow(context: context)
        } else {
            convertedToProminentHUDStyle().setupWindow(context: context)
        }
    }
    
    @MainActor
    public func updateWindow(context: HUDWindowContext) {
        if #available(macOS 26.0, *) {
            convertedToMenuPopoverHUDStyle().updateWindow(context: context)
        } else {
            convertedToProminentHUDStyle().updateWindow(context: context)
        }
    }
}

#endif
