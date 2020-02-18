/**
 SecondLimiter.swift
 Copyright (c) 2020 Callum Kerr-Edwards
 Licensed under the MIT license.
 */

import Foundation

/// The GoodReads API terms of service dictate that the API is not used more than once a second.
/// This class is used to ensure that the
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

    /// Retries the passed function so that even when rate limited it should still run.
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
}
