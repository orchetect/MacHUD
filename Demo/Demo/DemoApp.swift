//
//  DemoApp.swift
//  swift-hud • https://github.com/orchetect/swift-hud
//

import SwiftUI
import SwiftHUD

@main
struct DemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    await HUDManager.shared.warm()
                }
        }
    }
}
