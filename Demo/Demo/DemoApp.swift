//
//  DemoApp.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

import AppKit
import MacHUD
import MenuBarExtraAccess
import SwiftUI

@main
struct DemoApp: App {
    @State private var isMenuPresented: Bool = false
    @State private var statusItem: NSStatusItem?
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.statusItem, statusItem)
                .task {
                    await HUDManager.shared.prewarm()
                }
        }
        .defaultSize(width: 800, height: 1100)
        
        MenuBarExtra("Demo", systemImage: "bubble.fill") {
            Button("Quit") { NSApp.terminate(nil) }
        }
        .menuBarExtraAccess(isPresented: $isMenuPresented) { statusItem in
            self.statusItem = statusItem
        }
    }
}
