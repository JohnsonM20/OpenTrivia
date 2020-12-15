//
//  QuestionViewController.swift
//  FirstQuizGame
//
//  Created by Matthew Johnson on 9/24/19.
//  Copyright © 2019 Matthew Johnson. All rights reserved.
//

import UIKit
import JavaScriptCore
import Foundation
import AVFoundation

class QuestionViewController: UIViewController {
    
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var answerButtons: [UIButton]!
    @IBOutlet var progressBar: UIProgressView!

    var b1Pressed = false
    var b2Pressed = false
    var b3Pressed = false
    var b4Pressed = false
    
    var isFirstGuess = true
    var guessedCorrectAnswer = false
    var correctAnswerNumber = 0
    var progressBarTimer: Timer!
    
    let dataStore = (UIApplication.shared.delegate as! AppDelegate).data
    var audioPlayer = AVAudioPlayer()
    
    override func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        
        if defaults.bool(forKey: "\(SoundTypes.isMusicPlaying)") {
            var randomSong = SoundTypes.allLightMusic.randomElement()!
            if dataStore.currentGameMode == GameTypes.timedMode {
                randomSong = SoundTypes.allFastMusic.randomElement()!
            }

            let AssortedMusics = NSURL(fileURLWithPath: Bundle.main.path(forResource: "\(randomSong)", ofType: "mp3")!)
            audioPlayer = try! AVAudioPlayer(contentsOf: AssortedMusics as URL)
            audioPlayer.prepareToPlay()
            audioPlayer.numberOfLoops = -1
            audioPlayer.play()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor(red: 0/255.0, green: 180/255.0, blue: 106/255.0, alpha: 1.0).cgColor, UIColor(red: 63/255.0, green: 161/255.0, blue: 200/255.0, alpha: 1.0).cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)

        progressBar.transform = progressBar.transform.scaledBy(x: 1, y: 4)
        progressBar.layer.cornerRadius = 10
        progressBar.clipsToBounds = true
        progressBar.layer.sublayers![1].cornerRadius = 10
        progressBar.subviews[1].clipsToBounds = true
        
        if (dataStore.currentGameMode == GameTypes.freePlay){
        } else if (dataStore.currentGameMode == GameTypes.timedMode){
            progressBar.progress = 1.0
            progressBarTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateProgressViewTimed), userInfo: nil, repeats: true)
        } else {
        }
        
        //make buttons rounded
        for i in 0...3{
            answerButtons[i].layer.cornerRadius = 20
        }
        
        askNextQuestion()
    }
    
    @IBAction func homePushed(_ sender: Any) {
        dataStore.playTinkSound()
    }
    
    @objc func updateProgressViewTimed(){
        progressBar.progress -= 0.0167
        progressBar.setProgress(progressBar.progress, animated: true)
        if(progressBar.progress == 0.0){
            progressBarTimer.invalidate()
            performSegue(withIdentifier: "finished", sender: self)
        }
    }
    
    @objc func updateProgressViewMultiplayer(){
        progressBar.progress -= 0.25
        progressBar.setProgress(progressBar.progress, animated: true)
        if(progressBar.progress == 0.0){
            progressBarTimer.invalidate()
            performSegue(withIdentifier: "showRankings", sender: self)
        }
    }
    
    func getCategory() -> String{
        return String(dataStore.currentTriviaCategoryID)
    }
    
    func showNetworkError() {
        let alert = UIAlertController(title: "Whoops...",
        message: "There was an error accessing the questions." + " Please try again.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        present(alert, animated: true, completion: nil)
        alert.addAction(action)
    }
    
    func askNextQuestion(){
        resetButtons()
        if dataStore.amountOfQuestionsAnswered < dataStore.totalAmountOfQuestions{
            if (dataStore.currentGameMode == GameTypes.freePlay){
                progressBar.progress = Float(dataStore.amountOfQuestionsAnswered)/Float(dataStore.totalAmountOfQuestions)
                
            } else if (dataStore.currentGameMode == GameTypes.timedMode){
            } else if (dataStore.currentGameMode == GameTypes.joinMultiplayer || dataStore.currentGameMode == GameTypes.startMultiplayer){
                progressBar.progress = 1
                progressBarTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateProgressViewMultiplayer), userInfo: nil, repeats: true)
            }
            questionLabel.text = dataStore.questions[dataStore.amountOfQuestionsAnswered].getQuestion().html2String
            let answers = dataStore.questions[dataStore.amountOfQuestionsAnswered].getAnswers()
            if dataStore.questions[dataStore.amountOfQuestionsAnswered].getQuestionType() == QuestionTypes.multiple{
                
                for i in 0 ..< answerButtons.count{
                    answerButtons[i].setTitle("\(answers.answerArray[i][0])".html2String, for: UIControl.State.normal)
                }
            } else {
                for i in 0...1{
                    answerButtons[i].setTitle("\(answers.answerArray[i][0])".html2String, for: UIControl.State.normal)
                }
                
                for i in 2...3{
                    answerButtons[i].isEnabled = false
                    answerButtons[i].setTitle("", for: UIControl.State.normal)
                    answerButtons[i].backgroundColor = UIColor.clear
                }
            }
            
            correctAnswerNumber = answers.answerSlot
            dataStore.amountOfQuestionsAnswered += 1
            
        } else {
            performSegue(withIdentifier: "finished", sender: self)
        }
    }
 
    func resetButtons(){
        b1Pressed = false
        b2Pressed = false
        b3Pressed = false
        b4Pressed = false
        guessedCorrectAnswer = false
        isFirstGuess = true
        
        for i in 0...3{
            if #available(iOS 13.0, *) {
                answerButtons[i].backgroundColor = UIColor.tertiaryLabel
            } else {
                answerButtons[i].backgroundColor = UIColor.gray
            }
            answerButtons[i].isEnabled = true
        }
    }
    
    @IBAction func Button1(_ sender: UIButton) {
        if (b1Pressed == false && correctAnswerNumber == 0){
            correctButtonPressed(sender: sender)

        }else if (b1Pressed == false && guessedCorrectAnswer == false){
            wrongButtonPressed(sender: sender)
        }
        b1Pressed = true
        isFirstGuess = false
    }
    @IBAction func Button2(_ sender: UIButton) {
        if (b2Pressed == false && correctAnswerNumber == 1){
            correctButtonPressed(sender: sender)
            
        }else if (b2Pressed == false && guessedCorrectAnswer == false){
            wrongButtonPressed(sender: sender)
        }
        b2Pressed = true
        isFirstGuess = false
    }
    @IBAction func Button3(_ sender: UIButton) {
        if (b3Pressed == false && correctAnswerNumber == 2){
            correctButtonPressed(sender: sender)
        }else if (b3Pressed == false && guessedCorrectAnswer == false){
            wrongButtonPressed(sender: sender)
        }
        b3Pressed = true
        isFirstGuess = false
    }
    @IBAction func Button4(_ sender: UIButton) {
        if (b4Pressed == false && correctAnswerNumber == 3){
            correctButtonPressed(sender: sender)
        }else if (b4Pressed == false && guessedCorrectAnswer == false){
            wrongButtonPressed(sender: sender)
        }
        b4Pressed = true
        isFirstGuess = false
    }
    
    func correctButtonPressed(sender: UIButton){
        dataStore.playCorrectSound()
        if isFirstGuess == true{
            dataStore.amountOfInitialCorrectAnswers += 1
        }
        if dataStore.currentGameMode == GameTypes.timedMode{
            if(progressBar.progress == 0.0){
                progressBarTimer.invalidate()
                performSegue(withIdentifier: "finished", sender: self)
            }
        }
        guessedCorrectAnswer = true
        sender.backgroundColor = UIColor.green.withAlphaComponent(0.5)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if self.dataStore.currentGameMode == GameTypes.freePlay || self.dataStore.currentGameMode == GameTypes.timedMode {
                self.askNextQuestion()
            }
        }
    }
    
    func wrongButtonPressed(sender: UIButton){
        dataStore.playIncorrectSound()
        if dataStore.currentGameMode == GameTypes.timedMode{
            progressBar.progress -= 0.0167 * 5
            progressBar.setProgress(progressBar.progress, animated: true)
            if(progressBar.progress == 0.0){
                progressBarTimer.invalidate()
                performSegue(withIdentifier: "finished", sender: self)
            }
        }
        dataStore.amountOfTotalClicks += 1
        sender.backgroundColor = UIColor.red.withAlphaComponent(0.5)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        audioPlayer.stop()
        
        if segue.identifier == "showRankings" {
            if let nextViewController = segue.destination as? RankingsViewController {
                nextViewController.delegate = self
            }
        }
        
        if segue.identifier == "finished" {
            //if let nextViewController = segue.destination as? EndgameViewController {
                //print("Q's Current game mode: \(dataStore.currentGameMode)")
            //}
        }
    }
}
