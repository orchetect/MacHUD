//
//  HUDStyle Size.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

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

#endif
