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
    @State private var viewModel = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(viewModel)
                .task {
                    await HUDManager.shared.prewarm()
                }
        }
        .defaultSize(width: 800, height: 1100)
        
        MenuBarExtra("Demo", systemImage: "bubble.fill") {
            if #available(macOS 26.0, *) { } else {
                Button("Menubar extra is only used for macOS 26 popover HUDs") { }.disabled(true)
                Divider()
            }
            Button("Quit") { NSApp.terminate(nil) }
        }
        .menuBarExtraAccess(isPresented: $isMenuPresented) { statusItem in
            viewModel.statusItem = statusItem
        }
    }
}
