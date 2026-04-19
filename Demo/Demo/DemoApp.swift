//
//  DemoApp.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import AppKit
import MacHUD
import MenuBarExtraAccess
import SwiftUI

@main
struct DemoApp: App {
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
        .menuBarExtraAccess(isPresented: $viewModel.isMenuPresented) { statusItem in
            print("Got status item reference: \(statusItem)")
            viewModel.statusItem = statusItem
        }
    }
}
