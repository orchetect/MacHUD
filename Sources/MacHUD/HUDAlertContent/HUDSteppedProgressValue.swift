//
//  HUDSteppedProgressValue.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import SwiftUI

/// Stepped progress bar parameters for a HUD alert.
public struct HUDSteppedProgressValue {
    /// Progress bar value.
    public var value: HUDProgressValue
    
    /// Optional step value to display progress bar notches.
    public var step: HUDProgressValue.Step?
    
    /// - Parameters:
    ///   - value: Progress bar value.
    ///   - step: Optional step value to display progress bar notches.
    public init(_ value: HUDProgressValue, step: HUDProgressValue.Step? = nil) {
        self.value = value
        self.step = step
    }
}

extension HUDSteppedProgressValue: Equatable { }

extension HUDSteppedProgressValue: Hashable { }

extension HUDSteppedProgressValue: Sendable { }

// MARK: - HUDProgressValue Enum Case Static Constructors

extension HUDSteppedProgressValue {
    /// Unit interval (floating-point value between `0.0 ... 1.0`).
    public static func unitInterval(_ value: Double, step: HUDProgressValue.Step? = nil) -> Self {
        .init(.unitInterval(value), step: step)
    }
    
    /// Percentage between `0 ... 100`.
    public static func percent(_ value: Int, step: HUDProgressValue.Step? = nil) -> Self {
        .init(.percent(value), step: step)
    }
    
    /// Value within a given custom possible mix/max range.
    public static func value(
        _ value: Double,
        range: ClosedRange<Double> = 0.0 ... 1.0,
        step: HUDProgressValue.Step? = nil
    ) -> Self {
        .init(.value(value, range: range), step: step)
    }
}

// MARK: - HUDProgressValue Additional Static Constructors

extension HUDSteppedProgressValue {
    /// Unit interval (floating-point value between `0.0 ... 1.0`).
    @_disfavoredOverload
    public static func unitInterval(_ value: some BinaryFloatingPoint, step: HUDProgressValue.Step? = nil) -> Self {
        .init(.unitInterval(Double(value)), step: step)
    }
    
    /// Percentage between `0 ... 100`.
    @_disfavoredOverload
    public static func percent(_ value: some BinaryInteger, step: HUDProgressValue.Step? = nil) -> Self {
        .init(.percent(Int(value)), step: step)
    }
    
    /// Percentage between `0 ... 100`.
    @_disfavoredOverload
    public static func percent(_ value: some BinaryFloatingPoint, step: HUDProgressValue.Step? = nil) -> Self {
        .init(.percent(Int(value)), step: step)
    }
    
    /// Value within a given custom possible mix/max range.
    @_disfavoredOverload
    public static func value<B: BinaryInteger>(
        _ value: B,
        range: ClosedRange<B>,
        step: HUDProgressValue.Step? = nil
    ) -> Self {
        .init(.value(Double(value), range: Double(range.lowerBound) ... Double(range.upperBound)), step: step)
    }
    
    /// Value within a given custom possible mix/max range.
    @_disfavoredOverload
    public static func value<F: BinaryFloatingPoint>(
        _ value: F,
        range: ClosedRange<F> = 0.0 ... 1.0,
        step: HUDProgressValue.Step? = nil
    ) -> Self {
        .init(.value(Double(value), range: Double(range.lowerBound) ... Double(range.upperBound)), step: step)
    }
}

// MARK: - Properties (Value Proxy)

extension HUDSteppedProgressValue {
    /// Returns the value as a unit interval (floating-point value between `0.0 ... 1.0`).
    public var unitInterval: Double {
        value.unitInterval
    }
    
    /// Returns the value as a percentage value between `0 ... 100`.
    public var percentageValue: Int {
        value.percentageValue
    }
    
    /// Returns the value as a localized percentage string (ie: "56%").
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public var localizedPercentageString: String {
        value.localizedPercentageString
    }
    
    /// Returns the minimum and maximum value range.
    public var range: ClosedRange<Double> {
        value.range
    }
}

#endif
