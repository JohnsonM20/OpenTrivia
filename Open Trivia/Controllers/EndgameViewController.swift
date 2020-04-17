//
//  EndgameViewController.swift
//  FirstQuizGame
//
//  Created by Matthew Johnson on 10/3/19.
//  Copyright © 2019 Matthew Johnson. All rights reserved.
//

import UIKit

class EndgameViewController: UIViewController {
    var rightAnswers = 1
    var totalClicks = 1
    @IBOutlet var GuessLabel: UILabel!
    var currentGameMode = 0
    var questionController = QuestionViewController()
    var settings = SettingsViewController()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentGameMode = appDelegate.data.getGameMode()
        let questionData = appDelegate.data.getQuestionsAnsweredAndTotalGuesses()
        questionController.resetVarsForNextRound()
        rightAnswers = questionData.0
        totalClicks = questionData.1
        print(rightAnswers)
        print(totalClicks)
        
        if currentGameMode == 0{
            print(rightAnswers)
            print(totalClicks)
            GuessLabel.text = ("You guessed with \(Int(round(Float(rightAnswers)*100/Float(totalClicks))))% accuracy.")
        } else if currentGameMode == 1{
            GuessLabel.text = ("You answered a total of \(rightAnswers) questions correct.")
        } else {
            GuessLabel.isHidden = true
        }
        
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
