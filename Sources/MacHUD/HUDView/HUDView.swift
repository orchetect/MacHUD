//
//  HUDView.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation
import SwiftUI

/// Content view displayed in a HUD alert window.
/// This defines a view with an associated HUD style and a required initializer.
public protocol HUDView: View {
    associatedtype Style: HUDStyle
    
    init(content: HUDAlertContent, style: Style)
}

#endif
