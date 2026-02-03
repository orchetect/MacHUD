//
//  DemoApp.swift
//  swift-hud • https://github.com/orchetect/swift-hud
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

import SwiftHUD
import SwiftUI

@main
struct DemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    await HUDManager.shared.warm()
                }
        }
        .defaultSize(width: 650, height: 800)
    }
}
