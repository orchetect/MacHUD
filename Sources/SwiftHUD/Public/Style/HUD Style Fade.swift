//
//  HUD Style Fade.swift
//  swift-hud • https://github.com/orchetect/swift-hud
//

import Foundation

extension HUD.Style {
    public enum Fade {
        case defaultDuration
        case withDuration(TimeInterval)
        case noFade
    }
}

extension HUD.Style.Fade: Equatable { }

extension HUD.Style.Fade: Hashable { }

extension HUD.Style.Fade: Sendable { }
