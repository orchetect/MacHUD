//
//  Logging.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if Logging

import func Foundation.NSLog
import os.log

@available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *)
struct LoggerLogBackend: LogBackend {
    let logger = Logger(subsystem: "MacHUD", category: "General")

    func debug(_ message: String) {
        logger.debug("\(message)")
    }
}

struct NSLogBackend: LogBackend {
    func debug(_ message: String) {
        NSLog(message)
    }
}

#endif

protocol LogBackend: Sendable {
    func debug(_ message: String)
}

struct NoOpLogBackend: LogBackend {
    func debug(_ message: String) { }
}

let logger: any LogBackend = {
    #if Logging
    if #available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *) {
        return LoggerLogBackend()
    } else {
        return NSLogBackend()
    }
    #else
    return NoOpLogBackend()
    #endif
}()
