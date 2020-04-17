//
//  ResultArray.swift
//  Open Trivia
//
//  Created by Matthew Johnson on 2/6/20.
//  Copyright © 2020 Matthew Johnson. All rights reserved.
//

import Foundation

class ResultArray:Codable{
    var response_code: Int
    var results = [QuestionArray]()
}
