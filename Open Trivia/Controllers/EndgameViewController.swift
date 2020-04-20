//
//  EndgameViewController.swift
//  FirstQuizGame
//
//  Created by Matthew Johnson on 10/3/19.
//  Copyright © 2019 Matthew Johnson. All rights reserved.
//

import UIKit

class EndgameViewController: UIViewController {
    
    @IBOutlet var AccuracyLabel: UILabel!
    @IBOutlet weak var MotivationLabel: UILabel!
    let dataStore = (UIApplication.shared.delegate as! AppDelegate).data
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor(red: 0/255.0, green: 180/255.0, blue: 106/255.0, alpha: 1.0).cgColor, UIColor(red: 63/255.0, green: 161/255.0, blue: 200/255.0, alpha: 1.0).cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
        var motivationText = "Congratulations, you finished Open Trivia!"
        let freePlayDict: [Int:String] = [0:"You know, the point of the game is to guess everything right, not wrong!", 1:"You were better off just guessing!", 2:"How about going for another round?", 3:"How about aiming for 50% next time?", 4:"At least the glass is half full!", 5:"You are really making progress!", 6:"100% is in sight!", 7:"You are an Open Trivia master!"]
        
        let percentage = Int(round(Float(dataStore.amountOfInitialCorrectAnswers)*100/Float(dataStore.amountOfQuestionsAnswered)))
        if dataStore.currentGameMode == GameTypes.freePlay{
            if percentage == 0{
                motivationText = freePlayDict[0]!
            } else if percentage < 25 {
                motivationText = freePlayDict[1]!
            } else if percentage < 37 {
                motivationText = freePlayDict[2]!
            } else if percentage < 50 {
                motivationText = freePlayDict[3]!
            } else if percentage == 50 {
                motivationText = freePlayDict[4]!
            } else if percentage < 75 {
                motivationText = freePlayDict[5]!
            } else if percentage < 100 {
                motivationText = freePlayDict[6]!
            } else if percentage == 100 {
                motivationText = freePlayDict[7]!
            }
            MotivationLabel.text = motivationText
        }
        
        if dataStore.currentGameMode == GameTypes.freePlay{
            AccuracyLabel.text = ("You finished with \(percentage)% accuracy.")
        } else if dataStore.currentGameMode == GameTypes.timedMode{
            AccuracyLabel.text = ("You answered a total of \(dataStore.amountOfQuestionsAnswered) questions correct.")
            let defaults = UserDefaults.standard
            defaults.set(dataStore.amountOfQuestionsAnswered, forKey: "\(dataStore.currentTriviaCategoryID)")
        } else {
            AccuracyLabel.isHidden = true
        }
    }
}
