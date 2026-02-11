//
//  HUDProgressValue.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import SwiftUI

/// Progress bar parameters for a HUD alert.
public enum HUDProgressValue {
    /// Unit interval (floating-point value between `0.0 ... 1.0`).
    case unitInterval(Double)
    
    /// Percentage between `0 ... 100`.
    case percent(Int)
    
    /// Value within a given custom possible mix/max range.
    case value(value: Double, range: ClosedRange<Double> = 0.0 ... 1.0)
}

extension HUDProgressValue: Equatable { }

extension HUDProgressValue: Hashable { }

extension HUDProgressValue: Sendable { }

// MARK: - Static Constructors

extension HUDProgressValue {
    /// Unit interval (floating-point value between `0.0 ... 1.0`).
    @_disfavoredOverload
    public static func unitInterval(_ value: some BinaryFloatingPoint) -> Self {
        .unitInterval(Double(value))
    }
    
    /// Percentage between `0 ... 100`.
    @_disfavoredOverload
    public static func percent(_ value: some BinaryInteger) -> Self {
        .percent(Int(value))
    }
    
    /// Value within a given custom possible mix/max range.
    @_disfavoredOverload
    public static func value<F: BinaryFloatingPoint>(
        value: F,
        range: ClosedRange<F> = 0.0 ... 1.0
    ) -> Self {
        .value(value: Double(value), range: Double(range.lowerBound) ... Double(range.upperBound))
    }
}

// MARK: - Properties

extension HUDProgressValue {
    /// Returns the value as a unit interval (floating-point value between `0.0 ... 1.0`).
    public var unitInterval: Double {
        switch self {
        case .unitInterval(let double):
            return double
        case .percent(let int):
            return Double(int) / 100.0
        case .value(let value, let range):
            let safeAmount = value.clamped(to: range)
            
            // avoid division by zero
            guard range.upperBound > range.lowerBound else { return 1.0 }
            
            return (safeAmount - range.lowerBound) / (range.upperBound - range.lowerBound)
        }
    }
    
    /// Returns the value as a percentage value between `0 ... 100`.
    public var percentageValue: Int {
        Int(unitInterval * 100)
    }
    
    /// Returns the value as a localized percentage string (ie: "56%").
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public var localizedPercentageString: String {
        percentageValue.formatted(.percent)
    }
}

#endif
