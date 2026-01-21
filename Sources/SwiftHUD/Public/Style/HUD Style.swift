//
//  HUD Style.swift
//  swift-hud • https://github.com/orchetect/swift-hud
//

import Foundation

extension HUD {
    public struct Style {
        /// The amount of time for the HUD overlay to persist on screen before it is dismissed.
        public var stickyTime: TimeInterval
        
        /// Position on screen for the HUD to appear.
        public var position: Position
        
        /// HUD size.
        public var size: Size
        
        /// Background visual shading of the HUD overlay.
        public var shade: Shade
        
        /// Boolean determining whether the HUD overlay will have a visual border.
        public var bordered: Bool
        
        /// Fade-out behavior when the overlay is dismissed from the screen.
        public var fadeOut: Fade

        /// Initializes with custom values, defaulting `nil` parameters to appropriate values for the current platform.
        public init(
            stickyTime: TimeInterval? = nil,
            position: Position? = nil,
            size: Size? = nil,
            shade: Shade? = nil,
            bordered: Bool? = nil,
            fadeOut: Fade? = nil
        ) {
            self = Self.currentPlatform
			
            if let stickyTime = stickyTime {
                self.stickyTime = stickyTime
            }
			
            if let position = position {
                self.position = position
            }
			
            if let size = size {
                self.size = size
            }
			
            if let shade = shade {
                self.shade = shade
            }
			
            if let bordered = bordered {
                self.bordered = bordered
            }
			
            if let fadeOut = fadeOut {
                self.fadeOut = fadeOut
            }
        }
    }
}

extension HUD.Style: Equatable { }

extension HUD.Style: Hashable { }

extension HUD.Style: Sendable { }
