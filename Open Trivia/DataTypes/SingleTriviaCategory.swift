//
//  SingleTriviaCategory.swift
//  Open Trivia
//
//  Created by Matthew Johnson on 2/7/20.
//  Copyright © 2020 Matthew Johnson. All rights reserved.
//

import Foundation

class SingleTriviaCategory:Codable, CustomStringConvertible, Comparable
{
    static func < (lhs: SingleTriviaCategory, rhs: SingleTriviaCategory) -> Bool {
        return lhs.name < rhs.name
    }
    
    static func == (lhs: SingleTriviaCategory, rhs: SingleTriviaCategory) -> Bool {
        return lhs.name == rhs.name
    }
    
    var description: String {
        return "Category: \(id)"
    }
    
    var id = Int()
    var name = String()
}
