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

        let xml = try getRequest(api: "book/title", parameters: params)

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

    internal func getRequest(api: String, parameters: [String: String]) throws -> XML {
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
    case bookNotFoundError(_ message: String)
}
