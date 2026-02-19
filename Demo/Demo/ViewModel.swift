//
//  ViewModel.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

import AppKit
import Foundation

@MainActor @Observable
public class ViewModel {
    public weak var statusItem: NSStatusItem? = nil
    
    public init() { }
}

extension ViewModel: Sendable { }
