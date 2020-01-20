/**
 HTTPURLResponse+IsOk.swift
 Copyright (c) 2020 Callum Kerr-Edwards
 Licensed under the MIT license.
 */

import Foundation

extension HTTPURLResponse {
    func isResponseOK() -> Bool {
        (200 ... 299).contains(statusCode)
    }
}
