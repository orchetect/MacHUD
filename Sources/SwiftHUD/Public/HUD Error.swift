//
//  HUD Error.swift
//  swift-hud • https://github.com/orchetect/swift-hud
//

extension HUD {
    public enum HUDError: Error {
        case internalInconsistency(_ verboseError: String)
    }
}
