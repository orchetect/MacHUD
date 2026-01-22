//
//  HUDStyle Tint.swift
//  swift-hud • https://github.com/orchetect/swift-hud
//

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
