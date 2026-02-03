//
//  AnyHUDStyle+Helpers.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

// MARK: - Helpers

extension AnyHUDStyle {
    /// Returns all available HUD style concrete types.
    static func hudStyleTypes(customHUDStyles: [any HUDStyle.Type] = []) -> [any HUDStyle.Type] {
        // internal style types
        var hudStyles: [any HUDStyle.Type] = []
        hudStyles.append(ProminentHUDStyle.self)
        if #available(macOS 26.0, *) {
            hudStyles.append(NotificationHUDStyle.self)
        }
        
        // custom style types
        hudStyles.append(contentsOf: customHUDStyles)
        
        return hudStyles
    }
}

#endif
