//
//  DemoApp.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

import MacHUD
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
