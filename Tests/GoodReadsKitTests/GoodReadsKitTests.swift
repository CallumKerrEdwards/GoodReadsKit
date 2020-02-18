/**
 GoodReadsKitTests.swift
 Copyright (c) 2020 Callum Kerr-Edwards
 Licensed under the MIT license.
 */

@testable import GoodReadsKit
import XCTest

final class GoodReadsKitTests: XCTestCase {
    // Add API key to test
    let api = GoodReads(apiKey: "dummy-key")

    func testGoodReadsBooksAPI() {
        do {
            let oathbringer = try api.getBook(title: "Oathbringer", author: "Sanderson")
            XCTAssertEqual(oathbringer.description, "Oathbringer by Brandon Sanderson. GoodReads ID: 34002132")
            XCTAssertEqual(oathbringer.seriesTitle!, "The Stormlight Archive")
            XCTAssertEqual(oathbringer.seriesEntry!, 3)
            XCTAssertEqual(oathbringer.getDateString()!, "2017-11-14")

            let wor = try api.getBook(title: "Words of Radiance", author: "Sanderson")
            XCTAssertEqual(wor.description, "Words of Radiance by Brandon Sanderson. GoodReads ID: 17332218")
            XCTAssertEqual(wor.seriesTitle!, "The Stormlight Archive")
            XCTAssertEqual(wor.seriesEntry!, 2)
            XCTAssertEqual(wor.getDateString()!, "2014-03-04")

            let twok = try api.getBook(title: "Way of Kings", author: "Sanderson")
            XCTAssertEqual(twok.description, "The Way of Kings by Brandon Sanderson. GoodReads ID: 7235533")
            XCTAssertEqual(twok.seriesTitle!, "The Stormlight Archive")
            XCTAssertEqual(twok.seriesEntry!, 1)
            XCTAssertEqual(twok.getDateString()!, "2010-08-31")

            let tIHYLtTW = try api.getBook(title: "This Is How You Lose the Time War", author: "Max Gladstone")
            XCTAssertEqual(tIHYLtTW.description, "This Is How You Lose the Time War by Amal El-Mohtar & Max Gladstone. GoodReads ID: 43352954")
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
            "Amal El-Mohtar",
            "Max Gladstone"
          ],
          "bookDescription" : "Among the ashes of a dying world, an agent of the Commandant finds a letter. It reads: Burn before reading.<br \\/><br \\/>And thus begins an unlikely correspondence between two rival agents hellbent on securing the best possible future for their warring factions. Now, what began as a taunt, a battlefield boast, grows into something more.<br \\/><br \\/>Except discovery of their bond would be death for each of them. There’s still a war going on, after all. And someone has to win that war. That’s how war works. Right?",
          "goodReadsID" : "43352954",
          "publicationDay" : 16,
          "publicationMonth" : 7,
          "publicationYear" : 2019,
          "title" : "This Is How You Lose the Time War"
        }
        """

        do {
            let book = try api.getBook(title: "This Is How You Lose the Time War", author: "Max Gladstone")

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
        ("testGoodReadsBooksAPI", testGoodReadsBooksAPI),
        ("testBookToJSON", testBookToJSON),
    ]
}
