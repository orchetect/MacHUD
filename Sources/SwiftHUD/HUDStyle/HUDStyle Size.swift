//
//  HUDStyle Size.swift
//  swift-hud • https://github.com/orchetect/swift-hud
//

import Foundation

extension HUDStyle {
    public enum Size: Int {
        case small
        case medium
        case large
        case extraLarge
    }
}

extension HUDStyle.Size: Equatable { }

extension HUDStyle.Size: Hashable { }

extension HUDStyle.Size: CaseIterable { }

extension HUDStyle.Size: Sendable { }
