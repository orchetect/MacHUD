//
//  HUD Style Size.swift
//  swift-hud • https://github.com/orchetect/swift-hud
//

import Foundation

extension HUD.Style {
    public enum Size: Int {
        case small
        case medium
        case large
        case superLarge
    }
}

extension HUD.Style.Size: Equatable { }

extension HUD.Style.Size: Hashable { }

extension HUD.Style.Size: CaseIterable { }

extension HUD.Style.Size: Sendable { }
