//
//  HUDStyleID.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation

struct HUDStyleID {
    let hudStyle: any HUDStyle.Type
    let id: String
    
    init(hudStyle: (some HUDStyle).Type) {
        self.hudStyle = hudStyle
        id = "\(type(of: hudStyle))"
    }
}

extension HUDStyleID: Equatable {
    static func == (lhs: HUDStyleID, rhs: HUDStyleID) -> Bool {
        lhs.id == rhs.id
    }
}

extension HUDStyleID: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension HUDStyleID: Sendable { }

#endif
