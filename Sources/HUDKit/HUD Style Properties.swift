//
//  HUD Style Properties.swift
//  HUDKit • https://github.com/orchetect/HUDKit
//

import Foundation

extension HUD.Style {
    public enum Position: Int, CaseIterable {
        case top
        case bottom
        case center
    }
}

extension HUD.Style {
    public enum Size: Int, CaseIterable {
        case small
        case medium
        case large
        case superLarge
    }
}

extension HUD.Style {
    public enum Shade: Int, CaseIterable {
        case light
        case mediumLight
        case dark
        case ultraDark
    }
}

extension HUD.Style {
    public enum Fade: Equatable, Hashable {
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
