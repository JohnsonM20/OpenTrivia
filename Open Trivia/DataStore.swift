//
//  dataStore.swift
//  Open Trivia
//
//  Created by Matthew Johnson on 2/6/20.
//  Copyright © 2020 Matthew Johnson. All rights reserved.
//

import Foundation
import AVFoundation

class DataStore{
    var currentGameMode = GameTypes.freePlay
    var allTriviaCategories: [SingleTriviaCategory] = []
    
    var amountOfQuestionsAnswered = 0
    var amountOfTotalClicks = 0
    var amountOfInitialCorrectAnswers = 0
    
    var currentTriviaCategoryID = 0
    var totalAmountOfQuestions = 0
    
    var responseCode: Int = 0
    var questions: [QuestionArray] = []
    
    let defaults = UserDefaults.standard
    var audioPlayer = AVAudioPlayer()
    
    init() {
        getTriviaCategoriesFromAPI()
    }
    
    func playTinkSound(){
        if defaults.bool(forKey: SoundTypes.useSoundEffects) {
            let systemSoundID: SystemSoundID = 1057
            AudioServicesPlaySystemSound (systemSoundID)
        }
    }
    
    func playClickSound(){
        if defaults.bool(forKey: SoundTypes.useSoundEffects) {
            let systemSoundID: SystemSoundID = 1104
            AudioServicesPlaySystemSound (systemSoundID)
        }
    }
    
    func playClickierSound(){
        if defaults.bool(forKey: SoundTypes.useSoundEffects) {
            let systemSoundID: SystemSoundID = 1105
            AudioServicesPlaySystemSound (systemSoundID)
        }
    }
    
    func playDoubleWrongBeepSound(){
        if defaults.bool(forKey: SoundTypes.useSoundEffects) {
            let systemSoundID: SystemSoundID = 1255
            AudioServicesPlaySystemSound (systemSoundID)
        }
    }
    
    func playRandomSound(){
        if defaults.bool(forKey: SoundTypes.useSoundEffects) {
            let systemSoundID: SystemSoundID = 1306
            AudioServicesPlaySystemSound (systemSoundID)
        }
    }
    
    func playCorrectSound(){
        if defaults.bool(forKey: SoundTypes.useSoundEffects) {
            let AssortedMusics = NSURL(fileURLWithPath: Bundle.main.path(forResource: "correct", ofType: "wav")!)
            audioPlayer = try! AVAudioPlayer(contentsOf: AssortedMusics as URL)
            audioPlayer.numberOfLoops = 0
            audioPlayer.play()
        }
    }
    
    func playIncorrectSound(){
        if defaults.bool(forKey: SoundTypes.useSoundEffects) {
            let AssortedMusics = NSURL(fileURLWithPath: Bundle.main.path(forResource: "wrong", ofType: "wav")!)
            audioPlayer = try! AVAudioPlayer(contentsOf: AssortedMusics as URL)
            audioPlayer.numberOfLoops = 0
            audioPlayer.play()
        }
    }
    
    func resetData(){
        amountOfQuestionsAnswered = 0
        amountOfTotalClicks = 0
        totalAmountOfQuestions = 0
        amountOfInitialCorrectAnswers = 0
        
        questions = []
    }
    
    func getTriviaCategoriesFromAPI(){
        
        let urlString = String(format: "https://opentdb.com/api_category.php")
        let url = URL(string: urlString)
        do{
            let data = try Data(contentsOf:url!)
            let decoder = JSONDecoder()
            let result = try decoder.decode(TriviaCategoryList.self, from:data)
            allTriviaCategories = result.trivia_categories
        } catch {
            do {
                let path = Bundle.main.path(forResource: "categories", ofType: "txt")
                let categoryString = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
                let data = categoryString.data(using: .utf8)
                let decoder = JSONDecoder()
                let result = try decoder.decode(TriviaCategoryList.self, from:data!)
                allTriviaCategories = result.trivia_categories
            }
            catch {print("error")}
        }
    }
    
    func getTriviaQuestionsFromAPI(finished: @escaping () -> Void){
        
        //let urlString = String(format:"https://opentdb.com/api.php?amount=\(self.totalAmountOfQuestions)&category=\(self.currentTriviaCategoryID)")
        // Replace all code after this with new code below // 1
        let queue = DispatchQueue.global()
        queue.async {
            do{
                var subtractQuestionsFromTotalIfError = 0
                repeat{
                    //print(subtractQuestionsFromTotalIfError)
                    let urlString = String(format:"https://opentdb.com/api.php?amount=\(self.totalAmountOfQuestions-subtractQuestionsFromTotalIfError)&category=\(self.currentTriviaCategoryID)")
                    let url = URL(string: urlString)
                    let JSONdata = try Data(contentsOf:url!)//, using: .utf8
                    let decoder = JSONDecoder()
                    let decodedJSON = try decoder.decode(ResultArray.self, from:JSONdata)
                    let results = decodedJSON.results
    
                    self.responseCode = decodedJSON.response_code
                    self.questions = results
                    if self.responseCode == 1{
                        subtractQuestionsFromTotalIfError+=1
                    }
                    //print("Response code: \(self.responseCode)")
                    
                } while self.responseCode != ResponseCodes.success
            } catch {
                do {
                    print("Went to txt!")
                    let path = Bundle.main.path(forResource: "questions", ofType: "txt") // file path for file "data.txt"
                    let categoryString = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
                    let data = categoryString.data(using: .utf8)
                    //print(data)
                    let decoder = JSONDecoder()
                    let decodedJSON = try decoder.decode(ResultArray.self, from:data!)
                    
                    let results = decodedJSON.results
                    self.responseCode = decodedJSON.response_code
                    self.questions = results
                } catch {print("error")}
            }
            //print("DONE!")
            finished()
        }
        
    }
}

struct GameTypes {
    static let freePlay = 0
    static let timedMode = 1
    static let startMultiplayer = 2
    static let joinMultiplayer = 3
}

struct QuestionTypes {
    static let multiple = "multiple"
    static let timedMode = "boolean"
}

struct SoundTypes {
    static let allLightMusic: [String] = ["Happy Whistling Ukulele", "Horns", "Wakka Wakka"]
    static let allFastMusic: [String] = ["Goodnightmare"]

    static let isMusicPlaying = "isMusicPlaying"
    static let useSoundEffects = "useSoundEffects"
    
    static let didSetInitialValues = "didSetInitialValues"
}

struct ResponseCodes {
    static let success = 0
    static let tooManyQuestions = 1
    static let invalidURL = 2
    static let tokenDoesNotExist = 3
    static let tokenRanOutOfQuestions = 4
}

struct CellGameModeSections {
    static let freePlay = 3
    static let timedMode = 2
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
