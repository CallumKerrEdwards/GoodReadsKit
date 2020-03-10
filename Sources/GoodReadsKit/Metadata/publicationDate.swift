//
//  publicationDate.swift
//  GoodReadsKit
//
//  Created by Callum Kerson on 10/03/2020.
//

import Foundation

public struct PublicationDate: Equatable, Codable, Hashable {
    public let year: Int
    public let month: Int?
    public let day: Int?
    
    public var getDateAsString: String? {
        if let month = month {
            if let day = day {
                return "\(year)-\(String(format: "%02d", month))-\(String(format: "%02d", day))"
            } else {
                return "\(year)-\(String(format: "%02d", month))"
            }
        }
        return String(year)
    }
    
    
    public init(year: Int, month: Int?, day: Int?) {
        self.year = year
        self.month = month
        self.day = day
    }
}
