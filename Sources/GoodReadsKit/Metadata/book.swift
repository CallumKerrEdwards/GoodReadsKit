/**
 book.swift
 Copyright (c) 2020 Callum Kerr-Edwards
 Licensed under the MIT license.
 */

import Foundation

public struct BookMetadata: Equatable, Codable, Hashable {
    public var title: String
    public var authors: [Author]?
    public var goodReadsID: String?
    public var narrators: [Author]?
    public var illustrators: [Author]?
    public var series: Series?
    public var isbn: String?
    public var publicationDate: PublicationDate?
    public var summary: String?
    
    public init(title: String) {
        self.title = title
    }
}
