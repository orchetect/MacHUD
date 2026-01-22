//
//  HUDStyle Transition.swift
//  swift-hud • https://github.com/orchetect/swift-hud
//

import Foundation

extension HUDStyle {
    public enum Transition {
        case `default`
        case fade(duration: TimeInterval)
        case none
    }
}

extension HUDStyle.Transition: Equatable { }

extension HUDStyle.Transition: Hashable { }

extension HUDStyle.Transition: Sendable { }
