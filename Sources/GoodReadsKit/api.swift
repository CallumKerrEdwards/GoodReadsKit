/**
 api.swift
 Copyright (c) 2020 Callum Kerr-Edwards
 Licensed under the MIT license.
 */

import Foundation
import SwiftyXML

public protocol GoodReads {
    
    func getBook(title: String, author: String?) throws -> Book
}

public struct GoodReadsRESTAPI: GoodReads {
    let apiKey: String
    let limiter = SecondLimiter()

    public init(apiKey: String) {
        self.apiKey = apiKey
    }

    public func getBook(title: String, author: String?) throws -> Book {
        var params = ["title": title]

        if let author: String = author {
            params["author"] = author
        }
        return try getBook(apiPath: "book/title", parameters: params)
    }
    
    /// Gets book from GoodReadsID
    /// - Parameter goodReadsID: GoodReadsID of book
    public func getBook(goodReadsID: Int) throws -> Book {
        return try getBook(apiPath: "book/show/\(goodReadsID).xml")
    }
    
    
    /// Gets book from ISBN
    /// - Parameter isbn: ISBN (either standard or ISBN13)
    public func getBook(isbn: String) throws -> Book {
        var processISBN = isbn
        processISBN = processISBN.replacingOccurrences(of: "ISBN13", with: "")
        processISBN = processISBN.replacingOccurrences(of: "ISBN", with: "")
        guard let number = Int(processISBN) else {
            throw GoodReadsError.notAValidISBN(isbn)
        }
        return try getBook(apiPath: "book/isbn/\(number)")
    }
    
    /// Gets a book's metadata from GoodReads using the API definied at https://www.goodreads.com/api/
    /// - Parameters:
    ///   - apiPath: the specific API path
    ///   - parameters: the optional parameters for the API call
    func getBook(apiPath: String, parameters: [String: String] = [:]) throws -> Book {
        let xml = try getRequest(api: apiPath, parameters: parameters)

        var authors: [String] = []
        for author in xml.book.authors.author.xmlList! {
            authors.append(author[.key("name")].stringValue.trimmed)
        }

        return Book(title: xml.book.work.original_title.stringValue.trimmed,
                    goodReadsID: xml.book.id.stringValue.trimmed,
                    authors: authors,
                    seriesTitle: xml.book.series_works.series_work.series.title.string?.cleaned,
                    seriesEntry: xml.book.series_works.series_work.user_position.int,
                    isbn: xml.book.isbn.string?.cleaned,
                    publicationYear: xml.book.work.original_publication_year.int,
                    publicationMonth: xml.book.work.original_publication_month.int,
                    publicationDay: xml.book.work.original_publication_day.int,
                    description: xml.book.description.string?.cleaned)
    }

    internal func getRequest(api: String, parameters: [String: String] = [:]) throws -> XML {
        var url = URL(string: "https://www.goodreads.com")!
        url.appendPathComponent(api)
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!

        var fullParameters = parameters
        fullParameters["key"] = apiKey

        var queryItems: [URLQueryItem] = []

        for (k, v) in fullParameters {
            queryItems.append(URLQueryItem(name: k, value: v))
        }
        components.queryItems = queryItems

        let queryURL = components.url!

        let result = limiter.retry { () -> Result<(URLResponse, Data), Error> in
            URLSession.shared.performSynchronously(with: queryURL)
        }

        switch result {
        case let .failure(error):
            throw error
        case let .success((response, data)):
            guard let httpResponse = response as? HTTPURLResponse else {
                throw GoodReadsError.apiError("Request \(queryURL) did not return an HTTP response")
            }
            if !httpResponse.isResponseOK() {
                if httpResponse.statusCode == 404 {
                    throw GoodReadsError.bookNotFoundError("Request \(queryURL) did not find a valid book, status code \(httpResponse.statusCode)")
                } else {
                    throw GoodReadsError.apiError("Request \(queryURL) returned status code \(httpResponse.statusCode)")
                }
            }
            return XML(data: data)
        case .none:
            throw GoodReadsError.apiError("API Failed to execute.")
        }
    }
}

enum GoodReadsError: Error {
    case apiError(_ message: String)
    case notAValidISBN(_ message: String)
    case bookNotFoundError(_ message: String)
}
