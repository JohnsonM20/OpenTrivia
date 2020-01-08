//
//  EndgameViewController.swift
//  FirstQuizGame
//
//  Created by Matthew Johnson on 10/3/19.
//  Copyright © 2019 Matthew Johnson. All rights reserved.
//

import UIKit

class EndgameViewController: UIViewController {
    var rightAnswers = Int(1)
    var totalClicks = Int(1)
    @IBOutlet var GuessLabel: UILabel!
    var currentGameMode = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentGameMode = SettingsViewController.getCurrentGameMode()
        let questionData = QuestionViewController.getRightAnswersAndQuestionsAnswered()
        QuestionViewController.resetVarsForNextRound()
        rightAnswers = questionData.0
        totalClicks = questionData.1
        //print(rightAnswers)
        //print(totalClicks)
        
        if currentGameMode == 0{
            GuessLabel.text = ("You guessed with \(Int(round(Float(rightAnswers)*100/Float(totalClicks))))% accuracy.")
        } else if currentGameMode == 1{
            GuessLabel.text = ("You answered a total of \(rightAnswers) questions correct.")
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
