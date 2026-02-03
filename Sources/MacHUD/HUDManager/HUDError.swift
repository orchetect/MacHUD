//
//  HUDError.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
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
