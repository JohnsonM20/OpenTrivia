//
//  QuestionArrau.swift
//  Open Trivia
//
//  Created by Matthew Johnson on 2/6/20.
//  Copyright © 2020 Matthew Johnson. All rights reserved.
//

import Foundation

class QuestionArray: Codable, CustomStringConvertible {
    var description: String {
        return "Category: \(category ?? "None"), Type: \(type), Difficulty: \(difficulty ?? "None"), Question: \(question), Answer: \(correct_answer ), Incorrect Answers: \(incorrect_answers)"
    }
    
    var category: String? = ""
    var type: String = ""
    var difficulty: String? = ""
    var question: String = ""
    var correct_answer: String = ""
    var incorrect_answers = [] as [String]
    
    func getQuestion() -> String{
        return (question)
    }
    
    func getQuestionType() -> String {
        return (type)
    }

    func getAnswers() -> (answerArray: [Array<String>], answerSlot: Int){
        var answers = [Array<String>]()
        answers.append([correct_answer])
        for i in 0..<incorrect_answers.count{
            answers.append([incorrect_answers[i]])
        }
        answers = answers.shuffled()
        print("\(answers[0][0])")
        
        if "\(answers[0][0])" == "False" && answers.count == 2{
            answers[0][0] = "True"
            answers[1][0] = "False"
        }
        
        //print("correct answer:", answers.firstIndex(of: [correct_answer])!)//Use to print correct answer from button 0-3
        answers.append(["\(answers.firstIndex(of: [correct_answer])!)"])
        let answerSlot = answers.firstIndex(of: [correct_answer])!
        return (answers, answerSlot)
    }
    
}
