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
    case value(_ value: Double, range: ClosedRange<Double> = 0.0 ... 1.0)
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
    
    /// Percentage between `0 ... 100`.
    @_disfavoredOverload
    public static func percent(_ value: some BinaryFloatingPoint) -> Self {
        .percent(Int(value))
    }
    
    /// Value within a given custom possible mix/max range.
    @_disfavoredOverload
    public static func value<B: BinaryInteger>(
        _ value: B,
        range: ClosedRange<B>,
        step: Step? = nil
    ) -> Self {
        .value(Double(value), range: Double(range.lowerBound) ... Double(range.upperBound))
    }
    
    /// Value within a given custom possible mix/max range.
    @_disfavoredOverload
    public static func value<F: BinaryFloatingPoint>(
        _ value: F,
        range: ClosedRange<F> = 0.0 ... 1.0,
        step: Step? = nil
    ) -> Self {
        .value(Double(value), range: Double(range.lowerBound) ... Double(range.upperBound))
    }
}

// MARK: - Composition

extension HUDProgressValue {
    /// Return the progress value with a step value.
    public func stepped(_ step: Step?) -> HUDSteppedProgressValue {
        HUDSteppedProgressValue(self, step: step)
    }
}

// MARK: - Properties

extension HUDProgressValue {
    /// Returns the value as a unit interval (floating-point value between `0.0 ... 1.0`).
    public var unitInterval: Double {
        switch self {
        case let .unitInterval(double):
            return double
        case let .percent(int):
            return Double(int) / 100.0
        case let .value(value, range: range):
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
    
    /// Returns the minimum and maximum value range.
    public var range: ClosedRange<Double> {
        switch self {
        case let .unitInterval(double): 0.0 ... 1.0
        case let .percent(int): 0.0 ... 100.0
        case let .value(_, range: range): range
        }
    }
}

#endif
