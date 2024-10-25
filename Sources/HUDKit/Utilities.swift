//
//  Test Utilities.swift
//  HUDKit • https://github.com/orchetect/HUDKit
//

import Foundation
import Testing

extension TimeInterval {
    package var secondsToNanoseconds: UInt64 { UInt64(self * Self(NSEC_PER_SEC)) }
}
