//
//  HUDManager AlertBaseContentView.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import AppKit
import Combine
import SwiftUI
internal import SwiftExtensions

extension HUDManager {
    /// The base HUD view that wraps the inner view provided but the HUD style.
    public struct AlertBaseContentView: View {
        let content: HUDAlertContent
        let style: AnyHUDStyle
        
        init() {
            content = .text(" ")
            style = .currentPlatform()
        }
        
        init(content: HUDAlertContent, style: AnyHUDStyle = .currentPlatform()) {
            self.content = content
            self.style = style
        }
        
        init(content: HUDAlertContent, style: some HUDStyle) {
            self.content = content
            self.style = AnyHUDStyle(style)
        }
        
        public var body: some View {
            AnyView(style.base.createView(content: content))
                .fixedSize()
                .allowsHitTesting(false)
        }
    }
}

#endif
