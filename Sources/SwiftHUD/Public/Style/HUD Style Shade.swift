//
//  HUD Style Shade.swift
//  swift-hud • https://github.com/orchetect/swift-hud
//

import Foundation

extension HUD.Style {
    public enum Shade: Int {
        case light
        case mediumLight
        case dark
        case ultraDark
    }
}

extension HUD.Style.Shade: Equatable { }

extension HUD.Style.Shade: Hashable { }

extension HUD.Style.Shade: CaseIterable { }

extension HUD.Style.Shade: Sendable { }
