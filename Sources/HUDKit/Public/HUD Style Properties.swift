//
//  HUD Style Properties.swift
//  HUDKit • https://github.com/orchetect/HUDKit
//

import Foundation

extension HUD.Style {
    public enum Position: Int, CaseIterable, Sendable {
        case top
        case bottom
        case center
    }
}

extension HUD.Style {
    public enum Size: Int, CaseIterable, Sendable {
        case small
        case medium
        case large
        case superLarge
    }
}

extension HUD.Style {
    public enum Shade: Int, CaseIterable, Sendable {
        case light
        case mediumLight
        case dark
        case ultraDark
    }
}

extension HUD.Style {
    public enum Fade: Equatable, Hashable, Sendable {
        case defaultDuration
        case withDuration(TimeInterval)
        case noFade
		
        public static func == (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case (.defaultDuration, .defaultDuration):
                return true
				
            case let (.withDuration(a), .withDuration(b)) where a == b:
                return true
				
            case (.noFade, .noFade):
                return true
				
            default:
                return false
            }
        }
    }
}
