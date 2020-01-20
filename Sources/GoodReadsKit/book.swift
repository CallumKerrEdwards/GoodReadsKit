/**
 book.swift
 Copyright (c) 2020 Callum Kerr-Edwards
 Licensed under the MIT license.
 */

import Foundation

public struct Book: CustomStringConvertible, Codable {
    let title: String
    let goodReadsID: String
    let authors: [String]
    let seriesTitle: String?
    let seriesEntry: Int?
    let isbn: String?
    let publicationYear: Int?
    let publicationMonth: Int?
    let publicationDay: Int?
    let bookDescription: String?

    init(title: String, goodReadsID: String, authors: [String],
         seriesTitle: String? = nil, seriesEntry: Int? = nil,
         isbn: String? = nil,
         publicationYear: Int? = nil,
         publicationMonth: Int? = nil, publicationDay: Int? = nil,
         description: String? = nil) {
        self.title = title
        self.goodReadsID = goodReadsID
        self.authors = authors
        if let seriesTitle: String = seriesTitle {
            self.seriesTitle = seriesTitle.trim()
        } else {
            self.seriesTitle = seriesTitle
        }
        self.seriesEntry = seriesEntry
        self.isbn = isbn
        self.publicationYear = publicationYear
        self.publicationMonth = publicationMonth
        self.publicationDay = publicationDay
        bookDescription = description
    }

    public func getAuthorString() -> String {
        authors.joined(separator: ", ").replacingLastOccurrenceOfString(",", with: " &")
    }

    public var description: String {
        "\(title) by \(getAuthorString()). GoodReads ID: \(goodReadsID)"
    }
}

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
}
