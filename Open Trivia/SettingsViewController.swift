//
//  SettingsViewController.swift
//  FirstQuizGame
//
//  Created by Matthew Johnson on 10/2/19.
//  Copyright © 2019 Matthew Johnson. All rights reserved.
//

import UIKit

class TriviaCategoryTypes:Codable
{
    var trivia_categories = [TriviaCategory]()
    
}

class TriviaCategory:Codable, CustomStringConvertible, Comparable
{
    static func < (lhs: TriviaCategory, rhs: TriviaCategory) -> Bool {
        return lhs.name < rhs.name
    }
    
    static func == (lhs: TriviaCategory, rhs: TriviaCategory) -> Bool {
        return lhs.name == rhs.name
    }
    
    var description: String {
        return "Category: \(id)"
    }
    
    var id = Int()
    var name = String()
}

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var selectorBackground: UILabel!
    @IBOutlet var questionsAskedLabel: UILabel!
    @IBOutlet var minimumAllowedQuestions: UILabel!
    @IBOutlet var maximumAllowedQuestions: UILabel!
    @IBOutlet var playersConnected: UILabel!
    @IBOutlet var currentSelectedQuestionAmount: UILabel!
    @IBOutlet var questionNumberAskedSlider: UISlider!
    @IBOutlet var directions: UITextView!
    @IBOutlet var questionTypePicker: UIPickerView!
    @IBOutlet var highScore: UILabel!
    static var allTriviaCategories: [TriviaCategory] = []
    static var currentQuestionAmountAsked = 10
    static var currentTriviaCategoryID = 0
    static var currentRowSelectedInPicker = 0
    static var currentGameMode = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        print(SettingsViewController.currentGameMode)
        
        selectorBackground.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        selectorBackground.layer.cornerRadius = 15
        selectorBackground.layer.masksToBounds = true
        
        if SettingsViewController.currentGameMode == 0{
            questionNumberAskedSlider.isHidden = false
            questionsAskedLabel.isHidden = false
            minimumAllowedQuestions.isHidden = false
            maximumAllowedQuestions.isHidden = false
            highScore.isHidden = true
            selectorBackground.isHidden = false
            playersConnected.isHidden = true
            currentSelectedQuestionAmount.font = currentSelectedQuestionAmount.font.withSize(32)
            questionNumberAskedSlider.value = Float(SettingsViewController.getQuestionAmountAskedSliderValue()/5)
            currentSelectedQuestionAmount.text = String(Int(questionNumberAskedSlider.value)*5)
            directions.isHidden = true
        } else if SettingsViewController.currentGameMode == 1{
            questionNumberAskedSlider.isHidden = true
            questionsAskedLabel.isHidden = true
            minimumAllowedQuestions.isHidden = true
            maximumAllowedQuestions.isHidden = true
            playersConnected.isHidden = true
            highScore.isHidden = false
            selectorBackground.isHidden = true
            currentSelectedQuestionAmount.font = currentSelectedQuestionAmount.font.withSize(20)
            currentSelectedQuestionAmount.text = "You have one minute to answer as many questions correctly as you can. You gain 5 seconds for each correct answer, and lose 5 seconds for each wrong answer."
            SettingsViewController.currentQuestionAmountAsked=26 // maximum without causing error for certain categories
            directions.isHidden = true
        } else if SettingsViewController.currentGameMode == 2{
            questionNumberAskedSlider.isHidden = false
            questionsAskedLabel.isHidden = false
            minimumAllowedQuestions.isHidden = false
            maximumAllowedQuestions.isHidden = false
            highScore.isHidden = false
            directions.isHidden = false
            selectorBackground.isHidden = false
            playersConnected.isHidden = false
            directions.text = "You are the game controller! Choose game options, wait for all players to join, then press start! Each player gains up to ten points for each correct answer. You may only answer once. You must answer within the alloted 10 seconds. There is a bonus for giving a correct answer quickly. Answers are revealed when all players answer."
            //if directions is for joining players:
            //You have joined a game! Wait for the game controller to choose game options and for other players to join. Each player gains up to ten points for each correct answer. You may only answer once. You must answer within the alloted 10 seconds. There is a bonus for giving a correct answer quickly. Answers are revealed when all players answer.
            playersConnected.backgroundColor = UIColor.black.withAlphaComponent(0.1)
            playersConnected.layer.cornerRadius = 10
            playersConnected.layer.masksToBounds = true
            
            currentSelectedQuestionAmount.font = currentSelectedQuestionAmount.font.withSize(32)
            currentSelectedQuestionAmount.text = String(Int(questionNumberAskedSlider.value)*5)
        }
        
        questionTypePicker.dataSource = self
        questionTypePicker.delegate = self
        questionTypePicker.selectRow(SettingsViewController.currentRowSelectedInPicker, inComponent: 0, animated: true)

        
    }
    
    static func getTriviaCategoriesFromAPI(){
        
        let urlString = String(format: "https://opentdb.com/api_category.php")
        let url = URL(string: urlString)
        
        do{
            let data = try Data(contentsOf:url!)//, using: .utf8
            let decoder = JSONDecoder()
            let result = try decoder.decode(TriviaCategoryTypes.self, from:data)
            allTriviaCategories = result.trivia_categories
            //print(allTriviaCategories.count)
        } catch{
            print("f")
        }
    }
    
    static func setCurrentGameMode(GameMode: Int){
        if GameMode == 0{
            currentGameMode = 0
        } else if GameMode == 1{
            currentGameMode = 1
        } else if GameMode == 2{
            currentGameMode = 2
        }
    }
    
    static func getCurrentGameMode() -> Int{
        print("Current Game Mode: ", currentGameMode)
        return currentGameMode
    }
    
    @IBAction func ChangeQuestionNumberSliderActively(_ sender: Any) {
        let questionAmountAsked = Int(questionNumberAskedSlider.value)*5
        
        currentSelectedQuestionAmount.text = String(questionAmountAsked)
        SettingsViewController.currentQuestionAmountAsked = questionAmountAsked
        //print("Current questions asked: ", questionAmountAsked)
    }
    
    static func getQuestionAmountAskedSliderValue() -> Int{
        
        return currentQuestionAmountAsked
    }
    
    @IBAction func playButtonPushed(_ sender: Any) {
        SettingsViewController.currentRowSelectedInPicker = questionTypePicker.selectedRow(inComponent: 0)
        //print(SettingsViewController.currentRowSelectedInPicker)
        //print(SettingsViewController.currentQuestionAmountAsked)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return SettingsViewController.allTriviaCategories.count+1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        SettingsViewController.allTriviaCategories = SettingsViewController.allTriviaCategories.sorted()
        
        if row == 0{
            return NSAttributedString(string: "All Questions", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        } else {
            return NSAttributedString(string: SettingsViewController.allTriviaCategories[row-1].name.replacingOccurrences(of: "Entertainment: ", with: "").replacingOccurrences(of: "Science: ", with: ""), attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        }
    }
    
    static func getCurrentTriviaQuestionID() -> Int {
        return SettingsViewController.currentTriviaCategoryID
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        if row == 0{
            SettingsViewController.currentTriviaCategoryID = 0
        } else {
            SettingsViewController.currentTriviaCategoryID = SettingsViewController.allTriviaCategories[row-1].id
        }

    }

}
