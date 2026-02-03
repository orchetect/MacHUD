//
//  ProminentHUDStyle Position.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation

extension ProminentHUDStyle {
    public enum Position: Int {
        case top
        case bottom
        case center
    }
}

extension ProminentHUDStyle.Position: Equatable { }

extension ProminentHUDStyle.Position: Hashable { }

extension ProminentHUDStyle.Position: CaseIterable { }

extension ProminentHUDStyle.Position: Sendable { }

#endif
