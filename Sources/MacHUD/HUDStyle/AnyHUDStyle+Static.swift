//
//  AnyHUDStyle+Static.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

// MARK: - Static Constructors

extension AnyHUDStyle {
    /// HUD style appropriate for the current platform version.
    public static func currentPlatform() -> Self {
        if #available(macOS 26.0, *) {
            AnyHUDStyle(.notification())
        } else {
            AnyHUDStyle(.prominent())
        }
    }
}

#endif
