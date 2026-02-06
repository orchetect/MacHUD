//
//  HUDStyle+Internal.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import AppKit
import Foundation
import SwiftUI

// MARK: - Internal Methods

extension HUDStyle {
    /// Identifier uniquely identifying the style.
    @inline(__always)
    nonisolated static var id: HUDStyleID {
        HUDStyleID(hudStyle: Self.self)
    }
    
    /// Creates a new instance of the HUD view.
    @MainActor
    func createView(content: AlertContent) -> some View {
        ContentView(style: self, content: content)
    }
}

#endif
