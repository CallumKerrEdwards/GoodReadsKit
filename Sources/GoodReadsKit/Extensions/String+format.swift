/**
 String+trim.swift
 Copyright (c) 2020 Callum Kerr-Edwards
 Licensed under the MIT license.
 */

import Foundation

extension String {

    func replacingLastOccurrenceOfString(_ searchString: String,
                                         with replacementString: String) -> String {
        if let range = self.range(of: searchString,
                                  options: [.backwards],
                                  range: nil,
                                  locale: nil) {
            return replacingCharacters(in: range, with: replacementString)
        }
        return self
    }
    
    var isBlank: Bool {
        trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var trimmed: String {
        trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

    var cleaned: String? {
        if isBlank {
            return nil
        } else {
            return trimmed
        }
    }
}
