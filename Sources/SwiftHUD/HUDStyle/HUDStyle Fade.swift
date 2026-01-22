//
//  HUDStyle Fade.swift
//  swift-hud • https://github.com/orchetect/swift-hud
//

import Foundation

extension HUDStyle {
    public enum Fade {
        case `default`
        case duration(timeInterval: TimeInterval)
        case none
    }
}

extension HUDStyle.Fade: Equatable { }

extension HUDStyle.Fade: Hashable { }

extension HUDStyle.Fade: Sendable { }
