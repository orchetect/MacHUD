//
//  HUDStyle Tint.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation

extension HUDStyle {
    public enum Tint: Int {
        case light
        case mediumLight
        case dark
        case ultraDark
    }
}

extension HUDStyle.Tint: Equatable { }

extension HUDStyle.Tint: Hashable { }

extension HUDStyle.Tint: CaseIterable { }

extension HUDStyle.Tint: Sendable { }

#endif
