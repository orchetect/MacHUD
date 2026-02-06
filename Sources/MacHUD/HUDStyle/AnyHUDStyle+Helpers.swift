//
//  AnyHUDStyle+Helpers.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

// MARK: - Helpers

extension AnyHUDStyle {
    var concreteType: any HUDStyle.Type {
        type(of: base)
    }
}

#endif
