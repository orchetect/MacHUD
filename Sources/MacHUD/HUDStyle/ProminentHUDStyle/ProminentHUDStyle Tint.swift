//
//  ProminentHUDStyle Tint.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation

extension ProminentHUDStyle {
    public enum Tint: Int {
        case light
        case mediumLight
        case dark
        case ultraDark
    }
}

extension ProminentHUDStyle.Tint: Equatable { }

extension ProminentHUDStyle.Tint: Hashable { }

extension ProminentHUDStyle.Tint: CaseIterable { }

extension ProminentHUDStyle.Tint: Sendable { }

#endif
