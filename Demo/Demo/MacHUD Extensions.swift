//
//  MacHUD Extensions.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MacHUD

// MARK: - ProminentHUDStyle Position

extension ProminentHUDStyle.Position: @retroactive Identifiable {
    public var id: Self {
        self
    }
}

extension ProminentHUDStyle.Position {
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

// MARK: - ProminentHUDStyle Size

extension ProminentHUDStyle.Size: @retroactive Identifiable {
    public var id: Self {
        self
    }
}

extension ProminentHUDStyle.Size {
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

// MARK: - Transition

extension HUDTransition: @retroactive Identifiable {
    public var id: Self {
        self
    }
}

extension HUDTransition {
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

extension HUDTransition: @retroactive CaseIterable {
    public static var allCases: [HUDTransition] {
        [.default, .fade(duration: 0.05), .fade(duration: 0.8), .fade(duration: 2.0), .none]
    }
}
