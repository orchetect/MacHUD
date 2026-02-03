//
//  HUDStyle Transition.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
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
