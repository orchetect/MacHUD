//
//  HUDStyle Shade.swift
//  swift-hud • https://github.com/orchetect/swift-hud
//

import Foundation

extension HUDStyle {
    public enum Shade: Int {
        case light
        case mediumLight
        case dark
        case ultraDark
    }
}

extension HUDStyle.Shade: Equatable { }

extension HUDStyle.Shade: Hashable { }

extension HUDStyle.Shade: CaseIterable { }

extension HUDStyle.Shade: Sendable { }
