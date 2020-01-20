/**
 String+trim.swift
 Copyright (c) 2020 Callum Kerr-Edwards
 Licensed under the MIT license.
 */

import Foundation

extension String {
    func trim() -> String {
        trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}
