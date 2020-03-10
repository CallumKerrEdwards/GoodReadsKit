//
//  Author.swift
//  GoodReadsKit
//
//  Created by Callum Kerson on 10/03/2020.
//

import Foundation

/// A struct describing a book author
public struct Author: Equatable, Codable, Hashable, ExpressibleByStringLiteral {
    
    public let firstNames: String?
    public let lastName: String
    
    public var fullName: String {
        if let firstName = firstNames {
            return "\(firstName) \(self.lastName)"
        } else {
            return self.lastName
        }
    }
    
    public init(firstNames: String? = nil, lastName: String) {
        self.firstNames = firstNames
        self.lastName = lastName
    }
    
    
    /// Initalises Author from string, including special cases
    /// - Parameter fullName: Full name of author
    public init(fullName: String) {
        // Exceptions
        if fullName == "Ursula K. Le Guin" {
            self.init(firstNames: "Ursula K.", lastName: "Le Guin")
        } else {
            self.init(stringLiteral: fullName)
        }
    }
    
    
    /// Initalises Author from string
    /// - Parameter stringLiteral: full name of author
    public init(stringLiteral value: String) {
        var names = value.components(separatedBy: " ")
        if let lastName = names.last {
            names.removeLast(1)
            self.firstNames = names.joined(separator: " ")
            self.lastName = lastName
        } else {
            self.firstNames = nil
            self.lastName = value
        }
    }
}

public extension Array where Element == Author {
    
    
    /// Gets all authors in a single string
    var author: String {
        self.map{$0.fullName}.joined(separator: ", ").replacingLastOccurrenceOfString(",", with: " &")
    }
}
