//
//  MyHUDStyle.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MacHUD
import SwiftUI

/// Example custom HUD style.
struct MyHUDStyle: HUDStyle {
    var transitionIn: HUDTransition? = .opacity(duration: 1.0)
    var duration: TimeInterval = 1.0
    var transitionOut: HUDTransition? = .opacity(duration: 1.0)
    
    init() { }
    
    func windowStyleMask() -> NSWindow.StyleMask {
        [.fullSizeContentView]
    }
    
    @MainActor
    func setupWindow(context: HUDWindowContext) {
        // Set up window properties that remain consistent for all future HUD alerts of this style.
        
        context.setCornerRadius(radius: 10.0)
        context.window.contentView?.layer?.borderColor = .white
        context.window.contentView?.layer?.borderWidth = 3.0
        context.window.hasShadow = true
    }
    
    @MainActor
    func updateWindow(context: HUDWindowContext) {
        // Set up window properties that are specific to the alert content, and as such will need to be applied
        // every time a HUD alert is displayed.
        
        // position window on screen
        let size = context.window.frame.size
        let rect = NSRect(
            origin: CGPoint(
                x: (context.effectiveAlertScreenRect.width - size.width) / 2,
                y: (context.effectiveAlertScreenRect.height - size.height) / 2
            ),
            size: size
        )
        context.window.setFrame(rect, display: true)
    }
}

extension MyHUDStyle {
    struct AlertContent: HUDAlertContent {
        var title: String
        
        init(title: String) {
            self.title = title
        }
    }
}

extension MyHUDStyle {
    struct ContentView: HUDView {
        typealias Style = MyHUDStyle
        let style: Style
        let content: Style.AlertContent
        
        init(style: Style, content: Style.AlertContent) {
            self.style = style
            self.content = content
        }
        
        var body: some View {
            ZStack {
                Color(hue: .random(in: 0.0 ... 1.0), saturation: 1.0, brightness: 1.0)
                
                Text(content.title)
                    .font(.system(size: 72))
                    .padding(20)
                    .fixedSize()
            }
        }
    }
}

// MARK: - Static Constructor

extension HUDStyle where Self == MyHUDStyle {
    static var myStyle: MyHUDStyle { MyHUDStyle() }
}
