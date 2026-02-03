//
//  NotificationHUDStyle+View.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation
import SwiftUI

@available(macOS 26.0, *)
extension NotificationHUDStyle {
    public struct ContentView: View, HUDView {
        let content: HUDAlertContent
        let style: NotificationHUDStyle
        
        public init(content: HUDAlertContent, style: NotificationHUDStyle) {
            self.content = content
            self.style = style
        }
        
        public var body: some View {
            Text("Not yet implemented.")
                .font(.system(size: 48))
                .padding()
        }
    }
}

// MARK: - Xcode Previews

#if DEBUG
@available(macOS 26.0, *)
#Preview("Text") {
    NotificationHUDStyle.ContentView(
        content: .text("Test"),
        style: .default()
    )
}

#endif

#endif
