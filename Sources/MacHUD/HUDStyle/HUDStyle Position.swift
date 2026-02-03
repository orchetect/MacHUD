//
//  HUDStyle Position.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

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

#endif
