/**
 book.swift
 Copyright (c) 2020 Callum Kerr-Edwards
 Licensed under the MIT license.
 */

import Foundation

public struct Book: CustomStringConvertible, Codable {
    public let title: String
    public let goodReadsID: String
    public let authors: [String]
    public let seriesTitle: String?
    public let seriesEntry: Int?
    public let isbn: String?
    public let publicationYear: Int?
    public let publicationMonth: Int?
    public let publicationDay: Int?
    public let bookDescription: String?

    init(title: String, goodReadsID: String, authors: [String],
         seriesTitle: String? = nil, seriesEntry: Int? = nil,
         isbn: String? = nil,
         publicationYear: Int? = nil,
         publicationMonth: Int? = nil, publicationDay: Int? = nil,
         description: String? = nil) {
        self.title = title
        self.goodReadsID = goodReadsID
        self.authors = authors
        self.seriesTitle = seriesTitle
        self.seriesEntry = seriesEntry
        self.isbn = isbn
        self.publicationYear = publicationYear
        self.publicationMonth = publicationMonth
        self.publicationDay = publicationDay
        bookDescription = description
    }

    public func getDateString() -> String? {
        guard let year = publicationYear else { return nil }
        if let month = publicationMonth {
            if let day = publicationDay {
                return "\(year)-\(month)-\(day)"
            } else {
                return "\(year)-\(month)"
            }
        }
        return String(year)
    }

    public func getAuthorString() -> String {
        authors.joined(separator: ", ").replacingLastOccurrenceOfString(",", with: " &")
    }

    public var description: String {
        "\(title) by \(getAuthorString()). GoodReads ID: \(goodReadsID)"
    }
}
