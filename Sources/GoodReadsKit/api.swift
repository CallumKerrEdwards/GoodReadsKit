/**
 api.swift
 Copyright (c) 2020 Callum Kerr-Edwards
 Licensed under the MIT license.
 */

import Foundation
import SwiftyXML

open class GoodReads {
    let apiKey: String
    let limiter = SecondLimiter()

    init(apiKey: String) {
        self.apiKey = apiKey
    }

    func getBook(title: String, author: String?) throws -> Book {
        var params = ["title": title]

        if let author: String = author {
            params["author"] = author
        }

        let xml = try getRequest(api: "book/title", parameters: params)

        var authors: [String] = []
        for author in xml.book.authors.author.xmlList! {
            authors.append(author[.key("name")].stringValue)
        }
        return Book(title: xml.book.work.original_title.stringValue,
                    goodReadsID: xml.book.id.stringValue,
                    authors: authors,
                    seriesTitle: xml.book.series_works.series_work.series.title.string,
                    seriesEntry: xml.book.series_works.series_work.user_position.int,
                    isbn: xml.book.isbn.string,
                    description: xml.book.description.string)
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
