//
//  HUD Style Position.swift
//  swift-hud • https://github.com/orchetect/swift-hud
//

import Foundation

extension HUD.Style {
    public enum Position: Int {
        case top
        case bottom
        case center
    }
}

extension HUD.Style.Position: Equatable { }

extension HUD.Style.Position: Hashable { }

extension HUD.Style.Position: CaseIterable { }

extension HUD.Style.Position: Sendable { }
