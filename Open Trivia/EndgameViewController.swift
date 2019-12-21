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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let questionData = QuestionViewController.getRightAnswersAndQuestionsAnswered()
        QuestionViewController.resetVarsForNextRound()
        rightAnswers = questionData.0
        totalClicks = questionData.1
        print(rightAnswers)
        print(totalClicks)
        GuessLabel.text = ("You guessed with a \(Int(round(Float(rightAnswers)*100/Float(totalClicks))))% accuracy.")
        
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
