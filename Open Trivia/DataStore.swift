//
//  dataStore.swift
//  Open Trivia
//
//  Created by Matthew Johnson on 2/6/20.
//  Copyright © 2020 Matthew Johnson. All rights reserved.
//

import Foundation

class DataStore{
    
    var questionsAnswered = 0
    var totalGuesses = 0
    var gameMode = GameTypes.freePlay
    var sliderPercentDoneValue = Int()
    
    func setGameMode(_ mode: Int){
        gameMode = mode
    }
    
    func getGameMode() -> Int{
        return gameMode
    }
    
    func setQuestionsAnsweredAndTotalGuesses(questions: Int, guesses: Int){
        questionsAnswered = questions
        totalGuesses = guesses
    }
    
    func getQuestionsAnsweredAndTotalGuesses() -> (Int, Int){
        return (questions: questionsAnswered, guesses: totalGuesses)
    }
    
}

struct GameTypes {
    static let freePlay = 0
    static let timedMode = 1
    static let startMultiplayer = 2
    static let joinMultiplayer = 3
}

struct CellGameModeSections {
    static let freePlay = 4
    static let timedMode = 3
    static let startMultiplayer = 3
    static let joinMultiplayer = 3
    
    static func getNumberOfRowsInSection(gameMode: Int) -> Int{
        if gameMode == GameTypes.freePlay{
            return freePlay
        } else if gameMode == GameTypes.timedMode{
            return timedMode
        } else if gameMode == GameTypes.startMultiplayer{
            return startMultiplayer
        } else /*if gameMode == gameTypes.joinMultiplayer*/{
            return joinMultiplayer
        }
    }
}

//Convert html code to a regular string:
extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension String {
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}
