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

class TriviaCategory:Codable, CustomStringConvertible
{
    var description: String {
        return "Category: \(id)"
    }
    
    var id = Int()
    var name = String()
}

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var questionsAskedLabel: UILabel!
    @IBOutlet var minimumAllowedQuestions: UILabel!
    @IBOutlet var maximumAllowedQuestions: UILabel!
    @IBOutlet var currentSelectedQuestionAmount: UILabel!
    @IBOutlet var questionNumberAskedSlider: UISlider!
    @IBOutlet var questionTypePicker: UIPickerView!
    @IBOutlet var highScoreTimed: UILabel!
    static var allTriviaCategories: [TriviaCategory] = []
    static var currentQuestionAmountAsked = 10
    static var currentTriviaCategoryID = 0
    static var currentRowSelectedInPicker = 0
    static var currentGameMode = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        print(SettingsViewController.currentGameMode)
        
        if SettingsViewController.currentGameMode == 0{
            questionNumberAskedSlider.isHidden = false
            questionsAskedLabel.isHidden = false
            minimumAllowedQuestions.isHidden = false
            maximumAllowedQuestions.isHidden = false
            highScoreTimed.isHidden = true
            currentSelectedQuestionAmount.font = currentSelectedQuestionAmount.font.withSize(32)
            questionNumberAskedSlider.value = Float(SettingsViewController.getQuestionAmountAskedSliderValue()/5)
            currentSelectedQuestionAmount.text = String(Int(questionNumberAskedSlider.value)*5)
        } else if SettingsViewController.currentGameMode == 1{
            questionNumberAskedSlider.isHidden = true
            questionsAskedLabel.isHidden = true
            minimumAllowedQuestions.isHidden = true
            maximumAllowedQuestions.isHidden = true
            highScoreTimed.isHidden = false
            currentSelectedQuestionAmount.font = currentSelectedQuestionAmount.font.withSize(20)
            currentSelectedQuestionAmount.text = "You have one minute to answer as many questions correctly as you can. You gain 5 seconds for each correct answer, and lose 5 seconds for each wrong answer."
            SettingsViewController.currentQuestionAmountAsked=26 // maximum without causing error for certain categories
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
            //print("f")
        }
    }
    
    static func setCurrentGameMode(GameMode: Int){
        if GameMode == 0{
            currentGameMode = 0
        } else if GameMode == 1{
            currentGameMode = 1
        }
    }
    
    static func getCurrentGameMode() -> Int{
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

        if SettingsViewController.currentGameMode == 0{
            QuestionViewController.updateGameMode(gameMode: SettingsViewController.currentGameMode)
            
        } else if SettingsViewController.currentGameMode == 1{
            QuestionViewController.updateGameMode(gameMode: SettingsViewController.currentGameMode)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return SettingsViewController.allTriviaCategories.count+1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if row == 0{
            return NSAttributedString(string: "All Questions", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
            
        } else {
            //return SettingsViewController.allTriviaCategories[row-1].name.replacingOccurrences(of: "Entertainment: ", with: "").replacingOccurrences(of: "Science: ", with: "")
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
