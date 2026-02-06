//
//  MacHUD Extensions.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MacHUD
internal import SwiftExtensions

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

// MARK: - Transition

extension HUDTransition: @retroactive Identifiable {
    public var id: Self {
        self
    }
}

extension HUDTransition {
    var name: String {
        switch self {
        case let .opacity(duration: duration):
            return "Opacity fade \(duration.formatted(.number.precision(.fractionLength(1 ... 2)))) seconds"
        case let .scaleAndOpacity(scaleFactor: scaleFactor, duration: duration):
            let sf = if let scaleFactor = scaleFactor?.double {
                " \(scaleFactor.formatted(.number.precision(.fractionLength(1 ... 2))))x"
            } else {
                ""
            }
            let dur = duration.formatted(.number.precision(.fractionLength(1 ... 2)))
            return "Scale\(sf) and opacity fade \(dur) seconds"
        }
    }
}

extension HUDTransition: @retroactive CaseIterable {
    public static var allCases: [HUDTransition] {
        [
            .opacity(duration: 0.05),
            .opacity(duration: 0.4),
            .opacity(duration: 0.8),
            .opacity(duration: 2.0),
            .scaleAndOpacity(duration: 0.05),
            .scaleAndOpacity(scaleFactor: 0.9, duration: 0.4),
            .scaleAndOpacity(duration: 0.8),
            .scaleAndOpacity(duration: 2.0),
        ]
    }
}
