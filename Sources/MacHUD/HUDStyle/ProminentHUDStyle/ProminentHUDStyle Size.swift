//
//  ProminentHUDStyle Size.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation

extension ProminentHUDStyle {
    public enum Size: Int {
        case small
        case medium
        case large
        case extraLarge
    }
}

extension ProminentHUDStyle.Size: Equatable { }

extension ProminentHUDStyle.Size: Hashable { }

extension ProminentHUDStyle.Size: CaseIterable { }

extension ProminentHUDStyle.Size: Sendable { }

#endif
