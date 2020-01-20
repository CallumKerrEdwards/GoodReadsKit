/**
 Limiter.swift
 Copyright (c) 2020 Callum Kerr-Edwards
 Licensed under the MIT license.
 */

import Foundation

class SecondLimiter {
    let limit: TimeInterval = 1
    private(set) var lastExecutedAt: Date?
    private let syncQueue = DispatchQueue(label: "goodreadskit.ratelimit", attributes: [])

    @discardableResult func execute(_ block: () -> Void) -> Bool {
        let executed = syncQueue.sync { () -> Bool in
            let now = Date()
            let timeInterval = now.timeIntervalSince(lastExecutedAt ?? .distantPast)
            if timeInterval > limit {
                self.lastExecutedAt = now
                return true
            }
            return false
        }

        if executed {
            block()
        }

        return executed
    }

    func execute<T>(_ block: () -> T) -> T? {
        var value: T?
        execute {
            value = block()
        }
        return value
    }

    func retry<T>(_ block: () -> T) -> T? {
        var value: T?
        var i = 0
        while i < 10 {
            execute {
                value = block()
            }
            if let value: T = value {
                return value
            }
            i += 1
            do {
                usleep(100_000)
            }
        }
        return value
    }

    func reset() {
        syncQueue.sync {
            lastExecutedAt = nil
        }
    }
}
