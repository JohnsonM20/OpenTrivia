//
//  SettingsViewController.swift
//  FirstQuizGame
//
//  Created by Matthew Johnson on 10/2/19.
//  Copyright © 2019 Matthew Johnson. All rights reserved.
//

import UIKit

class CategoryTypes:Codable
{
    var trivia_categories = [Categories]()
    
}

class Categories:Codable, CustomStringConvertible
{
    var description: String {
        return "Category: \(id)"
    }
    
    var id = Int()
    var name = String()
}

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var TotalQNumber: UILabel!
    @IBOutlet var NumberLabel: UILabel!
    @IBOutlet var slider: UISlider!
    @IBOutlet var QuestionType: UIPickerView!
    static var results: [Categories] = []
    var currentQuestionsAsked = Int()
    var currentCategory = 9

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let Settings = SettingsViewController()


        
        slider.value = Float(getSliderValue())
        NumberLabel.text = String(Int(slider.value)*5)
        //
        QuestionType.dataSource = self
        QuestionType.delegate = self
        //
        //getCategories()
        
        
        
    }
    
    static func getCategories(){
        
        let urlString = String(format: "https://opentdb.com/api_category.php")
        let url = URL(string: urlString)
        
        do{
            let data = try Data(contentsOf:url!)//, using: .utf8
            let decoder = JSONDecoder()
            let result = try decoder.decode(CategoryTypes.self, from:data)
            results = result.trivia_categories
            print(results.count)
        } catch{
            print("f")
        }
    }
    
    
    @IBAction func ChangeSlider(_ sender: Any) {
        NumberLabel.text = String(Int(slider.value)*5)
        currentQuestionsAsked = Int(slider.value)
        
    }
    
    func getSliderValue() -> Int{
        print("gehiruaiegurhllai")
        let file = "quizData.txt"
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(file)
            do {
                currentQuestionsAsked = try (Int(String(contentsOf: fileURL, encoding: .utf8)) ?? 10)
            }
            catch {}
        }
        
        return currentQuestionsAsked
    }
    
    @IBAction func saveSettings(_ sender: Any) {
        let file = "quizData.txt"
        let text = String(currentQuestionsAsked)

        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(file)
            do {
                try text.write(to: fileURL, atomically: false, encoding: .utf8)
                
            }
            catch {}
        }

    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return SettingsViewController.results.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0{
            //return ("All Questions")
            return SettingsViewController.results[row].name.replacingOccurrences(of: "Entertainment: ", with: "").replacingOccurrences(of: "Science: ", with: "")
            
        } else {
            return SettingsViewController.results[row].name.replacingOccurrences(of: "Entertainment: ", with: "").replacingOccurrences(of: "Science: ", with: "")
        }
    }
    
    func getQuestionID() -> Int {
        return currentCategory
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        currentCategory = SettingsViewController.results[row].id
        print(currentCategory)
        
        let file = "Category.txt"
        let text = String(currentCategory)
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(file)
            do {
                try text.write(to: fileURL, atomically: false, encoding: .utf8)
                
            }
            catch {}
        }
        
        
        
        
    }

}
