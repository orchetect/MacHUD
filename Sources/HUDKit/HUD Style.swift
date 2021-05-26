//
//  HUD Style.swift
//  HUDKit
//
//  Created by Steffan Andrews on 2021-05-25.
//  Copyright © 2020 Steffan Andrews. All rights reserved.
//

import Foundation

extension HUD {
	
	public struct Style: Equatable, Hashable {
		
		public var stickyTime: TimeInterval
		public var position: Position
		public var size: Size
		public var shade: Shade
		public var bordered: Bool
		public var fadeOut: Fade
		
		/// Initializes with custom values.
		public init(
			stickyTime: TimeInterval,
			position: Position,
			size: Size,
			shade: Shade,
			bordered: Bool,
			fadeOut: Fade
		) {
			
			self.stickyTime = stickyTime
			self.position = position
			self.size = size
			self.shade = shade
			self.bordered = bordered
			self.fadeOut = fadeOut
			
		}
		
		/// Initializes with automatic values, overriding values that are non-nil.
		@_disfavoredOverload
		public init(
			stickyTime: TimeInterval? = nil,
			position: Position? = nil,
			size: Size? = nil,
			shade: Shade? = nil,
			bordered: Bool? = nil,
			fadeOut: Fade? = nil
		) {
			
			self = Self.preset_automatic
			
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

extension HUD.Style {
	
	/// Initializes with preset values.
	public init(_ preset: Preset) {
		
		switch preset {
		case .automatic:
			self = Self.preset_automatic
			
		case .macOS_10_15:
			self = Self.preset_macOS_10_15
			
		case .macOS_11_0:
			self = Self.preset_macOS_11_0
		}
		
	}
	
}

extension HUD.Style {
	
	public enum Preset {
		case automatic
		case macOS_10_15
		case macOS_11_0
	}
	
	internal static let preset_automatic: Self = {
		
		if #available(macOS 11.0, *) {
			return Self.preset_macOS_11_0
			
		} else if #available(macOS 10.15, *) {
			return Self.preset_macOS_10_15
			
		} else {
			return Self.preset_macOS_10_15
		}
		
	}()
	
	internal static let preset_macOS_10_15 = Self(
		stickyTime: 1.2,
		position: .bottom,
		size: .large,
		shade: .dark,
		bordered: false,
		fadeOut: .withDuration(0.8)
	)
	
	internal static let preset_macOS_11_0 = Self(
		stickyTime: 1.2,
		position: .bottom,
		size: .large,
		shade: .dark,
		bordered: false,
		fadeOut: .withDuration(0.8)
	)
	
}
