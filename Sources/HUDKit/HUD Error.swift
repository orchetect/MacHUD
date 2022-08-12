//
//  HUD Error.swift
//  HUDKit • https://github.com/orchetect/HUDKit
//

extension HUD {
    public enum HUDError: Error {
        case internalInconsistency(_ verboseError: String)
    }
}
