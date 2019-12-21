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

class SettingsSinglePlayerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var maximumAllowedQuestions: UILabel!
    @IBOutlet var currentSelectedQuestionAmount: UILabel!
    @IBOutlet var questionNumberAskedSlider: UISlider!
    @IBOutlet var questionTypePicker: UIPickerView!
    static var allTriviaCategories: [TriviaCategory] = []
    static var currentQuestionAmountAsked = 10
    static var currentTriviaCategoryID = 0
    static var currentRowSelectedInPicker = 3

    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionNumberAskedSlider.value = Float(SettingsSinglePlayerViewController.getQuestionAmountAskedSliderValue()/5)
        currentSelectedQuestionAmount.text = String(Int(questionNumberAskedSlider.value)*5)
        questionTypePicker.dataSource = self
        questionTypePicker.delegate = self

        questionTypePicker.selectRow(SettingsSinglePlayerViewController.currentRowSelectedInPicker, inComponent: 0, animated: true)

        
    }
    
    static func getTriviaCategoriesFromAPI(){
        
        let urlString = String(format: "https://opentdb.com/api_category.php")
        let url = URL(string: urlString)
        
        do{
            let data = try Data(contentsOf:url!)//, using: .utf8
            let decoder = JSONDecoder()
            let result = try decoder.decode(TriviaCategoryTypes.self, from:data)
            allTriviaCategories = result.trivia_categories
            print(allTriviaCategories.count)
        } catch{
            print("f")
        }
    }
    
    @IBAction func ChangeQuestionNumberSliderActively(_ sender: Any) {
        let questionAmountAsked = Int(questionNumberAskedSlider.value)*5
        
        currentSelectedQuestionAmount.text = String(questionAmountAsked)
        SettingsSinglePlayerViewController.currentQuestionAmountAsked = questionAmountAsked
        print("Current questions asked: ", questionAmountAsked)
    }
    
    static func getQuestionAmountAskedSliderValue() -> Int{
        
        return currentQuestionAmountAsked
    }
    
    @IBAction func saveButtonPushed(_ sender: Any) {
        SettingsSinglePlayerViewController.currentRowSelectedInPicker = questionTypePicker.selectedRow(inComponent: 0)
        print(SettingsSinglePlayerViewController.currentRowSelectedInPicker)
        print(SettingsSinglePlayerViewController.currentQuestionAmountAsked)

    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return SettingsSinglePlayerViewController.allTriviaCategories.count+1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0{
            return ("All Questions")
            //return SettingsSinglePlayerViewController.allTriviaCategories[row].name.replacingOccurrences(of: "Entertainment: ", with: "").replacingOccurrences(of: "Science: ", with: "")
            
        } else {
            return SettingsSinglePlayerViewController.allTriviaCategories[row-1].name.replacingOccurrences(of: "Entertainment: ", with: "").replacingOccurrences(of: "Science: ", with: "")
        }
    }
    
    static func getCurrentTriviaQuestionID() -> Int {
        return SettingsSinglePlayerViewController.currentTriviaCategoryID
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        if row == 0{
            SettingsSinglePlayerViewController.currentTriviaCategoryID = 0
        } else {
            SettingsSinglePlayerViewController.currentTriviaCategoryID = SettingsSinglePlayerViewController.allTriviaCategories[row-1].id
        }
        
        print(SettingsSinglePlayerViewController.currentTriviaCategoryID)
        
        let file = "Category.txt"
        let text = String(SettingsSinglePlayerViewController.currentTriviaCategoryID)
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(file)
            do {
                try text.write(to: fileURL, atomically: false, encoding: .utf8)
                
            }
            catch {}
        }

    }

}
