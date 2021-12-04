//
//  Log.swift
//  HUDKit • https://github.com/orchetect/HUDKit
//

@_implementationOnly import OTCore

let logger = OSLogger {
    #if RELEASE
    $0.defaultTemplate = .minimal()
    #else
    $0.defaultTemplate = .withEmoji()
    #endif
}
