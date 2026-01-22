//
//  HUDStyle Position.swift
//  swift-hud • https://github.com/orchetect/swift-hud
//

import Foundation

extension HUDStyle {
    public enum Position: Int {
        case top
        case bottom
        case center
    }
}

extension HUDStyle.Position: Equatable { }

extension HUDStyle.Position: Hashable { }

extension HUDStyle.Position: CaseIterable { }

extension HUDStyle.Position: Sendable { }
