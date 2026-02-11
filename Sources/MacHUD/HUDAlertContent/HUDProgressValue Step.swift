//
//  HUDProgressValue Step.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import SwiftUI

extension HUDProgressValue {
    public enum Step {
        case span(Double)
        case segmentCount(Int)
    }
}

extension HUDProgressValue.Step: Equatable { }

extension HUDProgressValue.Step: Hashable { }

extension HUDProgressValue.Step: Sendable { }

// MARK: - Properties

extension HUDProgressValue.Step {
    func segmentCount(for range: ClosedRange<Double>) -> Int? {
        switch self {
        case let .span(span):
            guard span > 0.0 else { return nil }
            
            // ensure a bounds are not equal
            guard range.upperBound > range.lowerBound else { return nil }
            
            let segments = (range.upperBound - range.lowerBound) / span
            
            return Int(segments)
            
        case let .segmentCount(count):
            return count
        }
    }
}

#endif
