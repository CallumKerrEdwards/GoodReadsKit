//
//  series.swift
//  GoodReadsKit
//
//  Created by Callum Kerson on 10/03/2020.
//

import Foundation

public struct Series: Codable, Equatable, Hashable {
    public let title: String
    public let entry: Double
    
    public var displayName: String {
        if entry.truncatingRemainder(dividingBy: 1.0) == 0.0 {
            return "Book \(Int(entry)) of \(title)"
        } else {
            return "Book \(entry) of \(title)"
        }
        
        
    }
}
