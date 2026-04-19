//
//  HUDManager Alert BaseContentView.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

internal import SwiftExtensions
import AppKit
import Combine
import SwiftUI

extension HUDManager.Alert {
    /// The base HUD view that wraps the inner view provided but the HUD style.
    public struct BaseContentView: View {
        let id: UUID = .init()

        let style: Style
        let content: Style.AlertContent?

        init() {
            style = Style()
            content = nil
        }

        init(content: Style.AlertContent, style: Style = Style()) {
            self.content = content
            self.style = style
        }

        public var body: some View {
            conditionalBody
                .compositingGroup()
                // .fixedSize()
                .allowsHitTesting(false)
                .id(id) // ensures state resets for each HUD alert
        }

        @ViewBuilder
        public var conditionalBody: some View {
            if let content {
                style.createView(content: content)
            } else {
                Text(verbatim: " ")
            }
        }
    }
}

#endif
