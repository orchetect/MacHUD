//
//  HUDManager AlertContent.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

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

#endif
