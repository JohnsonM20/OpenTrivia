//
//  EndgameViewController.swift
//  FirstQuizGame
//
//  Created by Matthew Johnson on 10/3/19.
//  Copyright © 2019 Matthew Johnson. All rights reserved.
//

import UIKit
import AVFoundation

class EndgameViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet var AccuracyLabel: UILabel!
    @IBOutlet weak var MotivationLabel: UILabel!
    
    let dataStore = (UIApplication.shared.delegate as! AppDelegate).data
    var audioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        
        backButton.backgroundColor = UIColor(red: 129/255.0, green: 204/255.0, blue: 197/255.0, alpha: 1.0)
        backButton.layer.shadowColor = UIColor(red: 90/255.0, green: 187/255.0, blue: 181/255.0, alpha: 1.0).cgColor
        backButton.layer.shadowOffset = CGSize(width: 0.0, height: 8.0)
        backButton.layer.shadowOpacity = 1.0
        backButton.layer.cornerRadius = 20.0
        backButton.layer.shadowRadius = 0.0
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor(red: 0/255.0, green: 180/255.0, blue: 106/255.0, alpha: 1.0).cgColor, UIColor(red: 63/255.0, green: 161/255.0, blue: 200/255.0, alpha: 1.0).cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
        var motivationText = "Congratulations, you finished Open Trivia!"
        let percentage = Int(round(Float(dataStore.amountOfInitialCorrectAnswers)*100/Float(dataStore.amountOfQuestionsAnswered)))
        
        if dataStore.currentGameMode == GameTypes.freePlay{
            if percentage == 0{
                motivationText = "You know, the point of the game is to guess everything right, not wrong!"
            } else if percentage < 25 {
                motivationText = "You were better off just guessing!"
            } else if percentage < 37 {
                motivationText = "How about going for another round?"
            } else if percentage < 50 {
                motivationText = "How about aiming for 50% next time?"
            } else if percentage == 50 {
                motivationText = "At least the glass is half full!"
            } else if percentage < 75 {
                motivationText = "You are really making progress!"
            } else if percentage < 100 {
                motivationText = "100% is in sight!"
            } else if percentage == 100 {
                motivationText = "You are an Open Trivia master!"
            }
        } else {
            let answers = dataStore.amountOfQuestionsAnswered
            let defaults = UserDefaults.standard
            
            if answers == dataStore.totalAmountOfQuestions {
                motivationText = "A wizard of trivia? You answered all the available questions for the category, so we must stop there!"
            } else if answers == 0{
                motivationText = "What happened out there? You didn't even get one :("
            } else if answers == 1 {
                motivationText = "Well ... one is better than none"
            } else if answers == 2 {
                motivationText = "You better think two-ice about that strategy again!"
            } else if answers <= 4 {
                motivationText = "Thats it? You can do better than that!"
            } else if answers <= 6 {
                motivationText = "I hope to see some improvement next time!"
            } else if defaults.integer(forKey: "\(dataStore.currentTriviaCategoryID)") != 0{
                let pointsFromHighScore = defaults.integer(forKey: "\(dataStore.currentTriviaCategoryID)") - dataStore.amountOfQuestionsAnswered
                if pointsFromHighScore >= 7{
                    motivationText = "You didn't even come close to your high score!"
                } else if pointsFromHighScore >= 3 {
                    motivationText = "You can see your old high score in front of you!"
                } else if pointsFromHighScore >= 1 {
                    motivationText = "Just a bit more brainpower will get you to pass that high score of yours!"
                } else if pointsFromHighScore == 0 {
                    motivationText = "At least you're consistant! You tied your high score."
                } else if pointsFromHighScore >= -2 {
                    motivationText = "You put in that extra work! You just beat your high score!"
                } else if pointsFromHighScore >= -4 {
                    motivationText = "What old high score? You know no limits!"
                } else {
                    motivationText = "Wow! You can't even see your old high score from up here!"
                }
            } else { // if player did well without high score
                if answers <= 8 {
                    motivationText = "Nice try, but I think that with practice you can do better!"
                } else if answers <= 10 {
                    motivationText = "That's a respectable game you just played!"
                } else if answers <= 12 {
                    motivationText = "You must know a lot!"
                } else {
                    motivationText = "Knowledge is power, and you have a good amount of knowledge."
                }
            }
        }
        MotivationLabel.text = motivationText
        
        if dataStore.currentGameMode == GameTypes.freePlay{
            AccuracyLabel.text = ("You finished with \(percentage)% accuracy.")
        } else if dataStore.currentGameMode == GameTypes.timedMode{
            AccuracyLabel.text = ("You answered a total of \(dataStore.amountOfQuestionsAnswered) questions correct.")
            let defaults = UserDefaults.standard
            
            if defaults.integer(forKey: "\(dataStore.currentTriviaCategoryID)") < dataStore.amountOfQuestionsAnswered{
                defaults.set(dataStore.amountOfQuestionsAnswered, forKey: "\(dataStore.currentTriviaCategoryID)")
            }
        } else {
            AccuracyLabel.isHidden = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        dataStore.playClickierSound()
        
    }
}
