//
//  HUDManager AlertContent.swift
//  swift-hud • https://github.com/orchetect/swift-hud
//

extension HUDManager {
    public enum AlertContent {
        case text(String)
        case image(systemName: String)
        case textAndImage(String, systemName: String)
    }
}

extension HUDManager.AlertContent: Equatable { }

extension HUDManager.AlertContent: Hashable { }

extension HUDManager.AlertContent: Sendable { }
