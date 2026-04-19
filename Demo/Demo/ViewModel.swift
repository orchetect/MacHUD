//
//  ViewModel.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import AppKit
import Foundation

@MainActor @Observable
public class ViewModel {
    public var isMenuPresented: Bool = false
    public weak var statusItem: NSStatusItem?

    public init() { }
}

extension ViewModel: Sendable { }
