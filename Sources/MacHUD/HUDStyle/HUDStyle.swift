//
//  HUDStyle.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
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
    
    var transitionIn: HUDTransition { get }
    var duration: TimeInterval { get }
    var transitionOut: HUDTransition { get }
    
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
    
    /// Initial setup when the alert window is first created.
    ///
    /// This method is not called every time an alert is displayed. Instead, it is only called when
    /// a new window is needed. Windows are cached and preserved for reuse with subsequent alerts.
    @MainActor
    func setupWindow(context: HUDWindowContext)
    
    /// This method is called when the alert window is first created after calling ``setupWindow(context:)``,
    /// and then also every time an alert is displayed.
    ///
    /// Implement this method if there are specific window modifications that need to be made based on
    /// the HUD alert content.
    ///
    /// For general window modifications that are only required for the HUD style, these can be performed
    /// by implementing the ``setupWindow(window:contentView:)`` method.
    @MainActor
    func updateWindow(context: HUDWindowContext)
}

// MARK: - Default Implementation

extension HUDStyle {
    public func windowStyleMask() -> NSWindow.StyleMask {
        [.borderless]
    }
    
    @MainActor
    public func setupWindow(context: HUDWindowContext) {
        // empty default implementation
    }
    
    @MainActor
    public func updateWindow(context: HUDWindowContext) {
        // empty default implementation
    }
}

#endif
