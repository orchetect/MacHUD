//
//  AnyHUDStyle+Static.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

// MARK: - Static Constructors

extension AnyHUDStyle {
    /// Default HUD style appropriate for the current platform version.
    static func platformDefault() -> Self {
        AnyHUDStyle(.platformDefault())
    }
}

#endif
