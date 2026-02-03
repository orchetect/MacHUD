//
//  AnyHUDStyle.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

public struct AnyHUDStyle {
    public var base: any HUDStyle
    
    public init(_ base: any HUDStyle) {
        self.base = base
    }
}

extension AnyHUDStyle: Equatable {
    public static func == (lhs: AnyHUDStyle, rhs: AnyHUDStyle) -> Bool {
        AnyHashable(lhs.base) == AnyHashable(rhs.base)
    }
}

extension AnyHUDStyle: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(base)
    }
}

extension AnyHUDStyle: Sendable { }

#endif
