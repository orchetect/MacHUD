//
//  Test Utilities.swift
//  swift-hud • https://github.com/orchetect/swift-hud
//

import Foundation
import Testing

extension TimeInterval {
    package var secondsToNanoseconds: UInt64 { UInt64(self * Self(NSEC_PER_SEC)) }
}
