//
//  HUDError.swift
//  swift-hud • https://github.com/orchetect/swift-hud
//

import Foundation

public enum HUDError: Error {
    case internalInconsistency(_ verboseError: String)
}

extension HUDError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .internalInconsistency(verboseError):
            "Internal inconsistency: \(verboseError)"
        }
    }
}
