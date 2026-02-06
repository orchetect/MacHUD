//
//  DefaultHUDStyle+View.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation
import SwiftUI

extension DefaultHUDStyle {
    public struct ContentView: View, HUDView {
        public typealias Style = DefaultHUDStyle
        let style: Style
        let content: Style.AlertContent
        
        public init(style: Style, content: Style.AlertContent) {
            self.content = content
            self.style = style
        }
        
        public var body: some View {
            if #available(macOS 26.0, *) {
                MenuPopoverHUDStyle.ContentView(
                    style: style.convertedToMenuPopoverHUDStyle(),
                    content: content.convertedToMenuPopoverHUDStyle()
                )
            } else {
                ProminentHUDStyle.ContentView(
                    style: style.convertedToProminentHUDStyle(),
                    content: content.convertedToProminentHUDStyle()
                )
            }
        }
    }
}

#endif
