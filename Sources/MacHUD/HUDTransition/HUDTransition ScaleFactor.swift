//
//  HUDTransition ScaleFactor.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation

extension HUDTransition {
    /// Pre-defined HUD alert transition scale factors.
    public enum ScaleFactor: Double {
        case percent90 = 0.9
        case percent50 = 0.5
    }
}
extension HUDTransition.ScaleFactor: Equatable { }

extension HUDTransition.ScaleFactor: Hashable { }

extension HUDTransition.ScaleFactor: CaseIterable { }

extension HUDTransition.ScaleFactor: Sendable { }

#endif
