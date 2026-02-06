//
//  AnyHUDStyle.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

/// Type-erased box containing a concrete HUD style instance.
struct AnyHUDStyle {
    public var base: any HUDStyle
    
    public init(_ base: any HUDStyle) {
        self.base = base
    }
}

extension AnyHUDStyle: Equatable {
    static func == (lhs: AnyHUDStyle, rhs: AnyHUDStyle) -> Bool {
        AnyHashable(lhs.base) == AnyHashable(rhs.base)
    }
}

extension AnyHUDStyle: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(base)
    }
}

extension AnyHUDStyle: Sendable { }

#endif
