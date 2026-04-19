//
//  HUDStyle.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import AppKit
import Foundation
import SwiftUI

/// HUD alert style defining an alert's window presentation and design.
public protocol HUDStyle: Equatable, Hashable, Sendable, SendableMetatype where ContentView.Style == Self {
    // MARK: - Static Constructors

    /// Initialize using default style properties for the current platform.
    init()

    // MARK: - Common properties

    /// Fade-out behavior when the alert is dismissed from the screen.
    /// `nil` presents the alert immediately without a transition.
    var transitionIn: HUDTransition? { get set }

    /// The amount of time for the HUD alert to persist on screen before it is dismissed, not including fade-in or
    /// fade-out time.
    var duration: TimeInterval { get set }

    /// Fade-out behavior when the alert is dismissed from the screen.
    /// `nil` dismisses the alert immediately without a transition.
    var transitionOut: HUDTransition? { get set }

    // MARK: - Window and View Content

    /// The view displayed in the HUD alert.
    associatedtype ContentView: HUDView
    associatedtype AlertContent: HUDAlertContent

    /// Optionally override the window's style mask.
    ///
    /// This style mask is passed into the window's initializer. This is useful since certain elements
    /// have different effects when a window is first initialized with them versus setting the mask after
    /// window creation.
    func windowStyleMask() -> NSWindow.StyleMask

    /// This method is called when a HUD alert window phase change occurs.
    ///
    /// - To configure the HUD window, respond to the `windowCreation` phase.
    /// - To update window content, respond to the `contentUpdate` phase.
    @MainActor
    func windowPhase(phase: HUDWindowPhase, context: HUDWindowContext)
}

// MARK: - Default Implementation

extension HUDStyle {
    public func windowStyleMask() -> NSWindow.StyleMask {
        [.borderless]
    }
}

#endif
