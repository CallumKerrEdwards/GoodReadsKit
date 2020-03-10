/**
 GoodReadsKitTests.swift
 Copyright (c) 2020 Callum Kerr-Edwards
 Licensed under the MIT license.
 */

@testable import GoodReadsKit
import XCTest

final class GoodReadsKitTests: XCTestCase {
    // Add API key to test
    let api = GoodReadsRESTAPI(apiKey: "rEFwN8mItCCt6CmxVtpxQ")

    func testGetBookFromTitleSearch() {
        do {
        let twok = try api.getBook(title: "Way of Kings", author: "Sanderson")
        XCTAssertEqual(twok.title, "The Way of Kings")
        XCTAssertEqual(twok.authors?.author, "Brandon Sanderson")
        XCTAssertEqual(twok.series?.displayName, "Book 1 of The Stormlight Archive")
        XCTAssertEqual(twok.publicationDate?.getDateAsString, "2010-08-31")
        } catch {
            print(error)
            XCTFail()
        }
    }
    
    func testGetBookByGoodReadsID() {
        do {
            let edgedancerAudiobook = try api.getBook(goodReadsID: 36414702)
            XCTAssertEqual(edgedancerAudiobook.title, "Edgedancer")
            XCTAssertEqual(edgedancerAudiobook.authors?.author, "Brandon Sanderson")
            XCTAssertEqual(edgedancerAudiobook.narrators?.author, "Kate Reading")
            XCTAssertEqual(edgedancerAudiobook.series?.displayName, "Book 2.5 of The Stormlight Archive")
            XCTAssertEqual(edgedancerAudiobook.publicationDate!.getDateAsString, "2016-11-22")
        } catch {
            print(error)
            XCTFail()
        }
    }
    
    func testGetBookWithMultipleAuthors() {
        do {
            let tIHYLtTW = try api.getBook(title: "This Is How You Lose the Time War", author: "Max Gladstone")
            XCTAssertEqual(tIHYLtTW.authors?.author, "Amal El-Mohtar & Max Gladstone")
        } catch {
            print(error)
            XCTFail()
        }
    }

    func testBookToJSON() {
        // Add API key to test

        let expectedJSON = """
        {
          "authors" : [
            {
              "firstNames" : "Brandon",
              "lastName" : "Sanderson"
            }
          ],
          "goodReadsID" : "36414702",
          "narrators" : [
            {
              "firstNames" : "Kate",
              "lastName" : "Reading"
            }
          ],
          "publicationDate" : {
            "day" : 22,
            "month" : 11,
            "year" : 2016
          },
          "series" : {
            "entry" : 2.5,
            "title" : "The Stormlight Archive"
          },
          "summary" : "<b>From #1<i> New York Times<\\/i> bestselling author Brandon Sanderson, a special gift edition of <i>Edgedancer<\\/i>, a short novel of the Stormlight Archive (previously published in <i>Arcanum Unbounded<\\/i>).<\\/b><br \\/><br \\/>Three years ago, Lift asked a goddess to stop her from growing older--a wish she believed was granted. Now, in <i>Edgedancer<\\/i>, the barely teenage nascent Knight Radiant finds that time stands still for no one. Although the young Azish emperor granted her safe haven from an executioner she knows only as Darkness, court life is suffocating the free-spirited Lift, who can't help heading to Yeddaw when she hears the relentless Darkness is there hunting people like her with budding powers. The downtrodden in Yeddaw have no champion, and Lift knows she must seize this awesome responsibility.",
          "title" : "Edgedancer"
        }
        """

        do {
            let book = try api.getBook(goodReadsID: 36414702)

            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]

            let jsonData = try! encoder.encode(book)
            let jsonString = String(data: jsonData, encoding: .utf8)!

            XCTAssertEqual(jsonString, expectedJSON)
        } catch {
            print(error)
            XCTFail()
        }
    }

    static var allTests = [
        ("testGetBookFromTitleSearch", testGetBookFromTitleSearch),
        ("testGetBookWithMultipleAuthors", testGetBookWithMultipleAuthors),
        ("testGetBookByGoodReadsID", testGetBookByGoodReadsID),
        ("testBookToJSON", testBookToJSON),
    ]
}
