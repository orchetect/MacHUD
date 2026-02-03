//
//  HUDStyle Extensions.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MacHUD

// MARK: - Position

extension HUDStyle.Position: @retroactive Identifiable {
    public var id: Self { self }
}

extension HUDStyle.Position {
    var name: String {
        switch self {
        case .top:
            "Top"
        case .bottom:
            "Bottom"
        case .center:
            "Center"
        }
    }
}

// MARK: - Size

extension HUDStyle.Size: @retroactive Identifiable {
    public var id: Self { self }
}

extension HUDStyle.Size {
    var name: String {
        switch self {
        case .small:
            "Small"
        case .medium:
            "Medium"
        case .large:
            "Large"
        case .extraLarge:
            "Extra Large"
        }
    }
}

// MARK: - Tint

extension HUDStyle.Tint: @retroactive Identifiable {
    public var id: Self { self }
}

extension HUDStyle.Tint {
    var name: String {
        switch self {
        case .light:
            "Light"
        case .mediumLight:
            "Medium Light"
        case .dark:
            "Dark"
        case .ultraDark:
            "Ultra Dark"
        }
    }
}

// MARK: - Transition

extension HUDStyle.Transition: @retroactive Identifiable {
    public var id: Self { self }
}

extension HUDStyle.Transition {
    var name: String {
        switch self {
        case .default:
            "Default"
        case let .fade(duration: duration):
            "Fade \(duration.formatted(.number.precision(.fractionLength(1 ... 2)))) seconds"
        case .none:
            "None"
        }
    }
}

extension HUDStyle.Transition: @retroactive CaseIterable {
    public static var allCases: [HUDStyle.Transition] {
        [.default, .fade(duration: 0.05), .fade(duration: 0.8), .fade(duration: 2.0), .none]
    }
}
