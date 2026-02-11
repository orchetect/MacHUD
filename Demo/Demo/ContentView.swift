//
//  ContentView.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

import AppKit
import MacHUD
import SwiftUI

struct ContentView: View {
    @State private var panel: Panel = .menuPopover
    
    var body: some View {
        NavigationSplitView {
            List(Panel.allCases, selection: $panel) {
                Label($0.name, systemImage: $0.systemImage)
                    .tag($0)
            }
            .navigationSplitViewColumnWidth(170)
        } detail: {
            switch panel {
            case .prominent:
                ProminentHUDView()
            case .menuPopover:
                if #available(macOS 26.0, *) {
                    MenuPopoverHUDView()
                } else {
                    Text("Menu popover HUD style is only available on macOS 26 and later.")
                }
            }
        }
    }
}

extension ContentView {
    enum Panel: String, CaseIterable, Identifiable {
        case prominent
        case menuPopover
        
        var name: String {
            switch self {
            case .prominent: "Prominent"
            case .menuPopover: "Menu Popover"
            }
        }
        
        var verboseName: String {
            switch self {
            case .prominent: "Prominent HUD Alerts"
            case .menuPopover: "Menu Popover HUD Alerts"
            }
        }
        
        var systemImage: String {
            switch self {
            case .prominent: "bell.square"
            case .menuPopover: "rectangle.compress.vertical"
            }
        }
        
        var id: RawValue { rawValue }
    }
}
