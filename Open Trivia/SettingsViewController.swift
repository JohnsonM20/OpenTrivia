//
//  SettingsViewController.swift
//  FirstQuizGame
//
//  Created by Matthew Johnson on 10/2/19.
//  Copyright © 2019 Matthew Johnson. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet var TotalQNumber: UILabel!
    @IBOutlet var SelectedQNumber: UILabel!
    @IBOutlet var slider: UISlider!
    var sliderQuestionPreferenceValue = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        slider.value = Float(getSliderValue())
        SelectedQNumber.text = String(Int(slider.value))
        
    }
    
    @IBAction func ChangeSlider(_ sender: Any) {
        SelectedQNumber.text = String(Int(slider.value))
        sliderQuestionPreferenceValue = Int(slider.value)
    }
    
    func getSliderValue() -> Int{
        let file = "quizData.txt"
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(file)
            do {
                sliderQuestionPreferenceValue = try (Int(String(contentsOf: fileURL, encoding: .utf8)) ?? 10)
            }
            catch {}
            
        }
        return sliderQuestionPreferenceValue
    }
    
    @IBAction func saveSettings(_ sender: Any) {
        print("Hello")
        
        
        
        let file = "quizData.txt"
        let text = String(sliderQuestionPreferenceValue)

        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(file)
            do {
                try text.write(to: fileURL, atomically: false, encoding: .utf8)
            }
            catch {}
        }
        
        
        
        
    }
    
    func getSelectedQuestionAmount() -> Int{
        
        return sliderQuestionPreferenceValue
    }


}
