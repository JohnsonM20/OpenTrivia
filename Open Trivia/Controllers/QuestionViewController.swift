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

class QuestionViewController: UIViewController {
    
    @IBOutlet var questionAskedLabel: UILabel!
    @IBOutlet var answerButtons: [UIButton]!
    @IBOutlet var progressBar: UIProgressView!
    var correctAnswerNumber = Int(0)
    var sliderPercentDoneValue = Int()
    var numRoundQuestions = Int()
    var questionsAnswered = Int(0)
    var wrongAnswers = Int(0)
    var response_code: Int = 0
    var resultsFromAPI: [QuestionArray] = []

    var b1Pressed = false
    var b2Pressed = false
    var b3Pressed = false
    var b4Pressed = false
    var guessedCorrectAnswer = false
    
    var progressBarTimer: Timer!
    var timer: Timer!
    
    var settings = SettingsViewController()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var currentGameMode: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentGameMode = appDelegate.data.getGameMode()
        questionsAnswered = 0
        
        progressBar.transform = progressBar.transform.scaledBy(x: 1, y: 5)
        progressBar.layer.cornerRadius = 10
        progressBar.clipsToBounds = true
        progressBar.layer.sublayers![1].cornerRadius = 10
        progressBar.subviews[1].clipsToBounds = true
        
        if (currentGameMode == 0){
        } else if (currentGameMode == 1){
            progressBar.progress = 1.0
            progressBarTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateProgressViewTimed), userInfo: nil, repeats: true)
        } else {
        }
        
        //make buttons rounded
        for i in 0...3{
            answerButtons[i].layer.cornerRadius = 20
        }
        
        do{
            var subtractQuestionsFromTotalIfError = 0
            repeat{
                let urlString = String(format:"https://opentdb.com/api.php?amount=\(getQuestionAmount()-subtractQuestionsFromTotalIfError)&category=\(getCategory())")
                let url = URL(string: urlString)
                let JSONdata = try Data(contentsOf:url!)//, using: .utf8
                let decoder = JSONDecoder()
                let decodedJSON = try decoder.decode(ResultArray.self, from:JSONdata)
                let results = decodedJSON.results
                //print(results)
                setDataFromCall(responseCodeFromCall: decodedJSON.response_code, resultsFromCall: results)
                print("Response Code: \(response_code)")
                if response_code == 1{
                    subtractQuestionsFromTotalIfError+=1
                }
            } while response_code != 0
            askNextQuestion()
        } catch {
            do {
                let path = Bundle.main.path(forResource: "questions", ofType: "txt") // file path for file "data.txt"
                let categoryString = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
                
                //print(categoryString)
                let data = categoryString.data(using: .utf8)
                //print(data)
                let decoder = JSONDecoder()
                let decodedJSON = try decoder.decode(ResultArray.self, from:data!)
                
                let results = decodedJSON.results
                setDataFromCall(responseCodeFromCall: decodedJSON.response_code, resultsFromCall: results)
            } catch {print("error")}
            askNextQuestion()
        }
    }
    
    @IBAction func homePushed(_ sender: Any) {
        //self.dismiss(animated: true, completion: nil)
    }
    
    //For Timed mode timer
    @objc func updateProgressViewTimed(){
        progressBar.progress -= 0.0167
        progressBar.setProgress(progressBar.progress, animated: true)
        if(progressBar.progress == 0.0){
            progressBarTimer.invalidate()
            performSegue(withIdentifier: "finished", sender: self)
            //let storyboardController = self.storyboard!.instantiateViewController(withIdentifier: "EndFreePlay")
            //self.present(storyboardController, animated: true, completion: nil)
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
        return String(settings.getCurrentTriviaQuestionID())
    }
    
    func getQuestionAmount() -> Int {
        //sets progress bar total questions asked
        numRoundQuestions = settings.getQuestionAmountAskedSliderValue()
        return settings.getQuestionAmountAskedSliderValue()
    }
    
    func setDataFromCall(responseCodeFromCall: Int, resultsFromCall: [QuestionArray]){
        response_code = responseCodeFromCall
        resultsFromAPI = resultsFromCall
    }
    
    func askNextQuestion(){
        resetButtons()
        //print("Questions answered so far")
        //print(questionsAnswered)
        if questionsAnswered < getQuestionAmount(){
            if (currentGameMode == 0){
                progressBar.progress = Float(questionsAnswered)/Float(numRoundQuestions)
            } else if (currentGameMode == 1){
                //progressBar.progress = 0.5
            } else if (currentGameMode == 2){
                progressBar.progress = 1
                progressBarTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateProgressViewMultiplayer), userInfo: nil, repeats: true)
            }
            
            questionAskedLabel.text = resultsFromAPI[questionsAnswered].getQuestion().replacingOccurrences(of: "&quot;", with: "'").replacingOccurrences(of:"&#039;", with:"'").replacingOccurrences(of:"&eacute;", with:"é").replacingOccurrences(of:"&amp;", with:"&")
            
            //print(resultsFromAPI[QuestionViewController.questionsAnswered].getQuestion())
            let answers = resultsFromAPI[questionsAnswered].getAnswers()
            //print("Question Type: ", resultsFromAPI[QuestionViewController.questionsAnswered].getQuestionType())
            if resultsFromAPI[questionsAnswered].getQuestionType() == "multiple"{
                for i in 0..<answerButtons.count{
                    //print(i)
                    //print(String("\(answers.0[i])"))
                    answerButtons[i].setTitle("\(answers.0[i][0])".replacingOccurrences(of: "&quot;", with: "'").replacingOccurrences(of:"&#039;", with:"'").replacingOccurrences(of:"&eacute;", with:"é").replacingOccurrences(of:"&ecirc;", with:"ê").replacingOccurrences(of:"&amp;", with:"&").replacingOccurrences(of:"&auml;", with:"ä").replacingOccurrences(of:"&ouml;", with:"ö"), for: UIControl.State.normal)
                }
            } else {
                for i in 0...1{
                    //print(i)
                    //print("\(answers.0[i])")
                    answerButtons[i].setTitle("\(answers.0[i][0])".replacingOccurrences(of: "&quot;", with: "'"), for: UIControl.State.normal)
                }
                
                for i in 2...3{
                    answerButtons[i].isEnabled = false
                    answerButtons[i].setTitle("", for: UIControl.State.normal)
                    answerButtons[i].backgroundColor = UIColor.clear
                }
            }
            //print(answers.0.last!)
            correctAnswerNumber = answers.1
            questionsAnswered += 1
            print("Total answers wrong: \(wrongAnswers)")
            
        } else {
            appDelegate.data.setQuestionsAnsweredAndTotalGuesses(questions: questionsAnswered, guesses: wrongAnswers+questionsAnswered)
            performSegue(withIdentifier: "finished", sender: self)
            //let storyboardController = self.storyboard!.instantiateViewController(withIdentifier: "EndFreePlay")
            //self.present(storyboardController, animated: true, completion: nil)
        }
    }
    
    func getRightAnswersAndQuestionsAnswered() -> (Int, Int){
        return (questionsAnswered, questionsAnswered+wrongAnswers)
    }
    
    func resetVarsForNextRound(){
        questionsAnswered = 0
        wrongAnswers = 0
    }
 
    func resetButtons(){
        b1Pressed = false
        b2Pressed = false
        b3Pressed = false
        b4Pressed = false
        guessedCorrectAnswer = false
        
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
    }
    @IBAction func Button2(_ sender: UIButton) {
        if (b2Pressed == false && correctAnswerNumber == 1){
            correctButtonPressed(sender: sender)
            
        }else if (b2Pressed == false && guessedCorrectAnswer == false){
            wrongButtonPressed(sender: sender)
        }
        b2Pressed = true
    }
    @IBAction func Button3(_ sender: UIButton) {
        if (b3Pressed == false && correctAnswerNumber == 2){
            correctButtonPressed(sender: sender)
        }else if (b3Pressed == false && guessedCorrectAnswer == false){
            wrongButtonPressed(sender: sender)
        }
        b3Pressed = true
    }
    @IBAction func Button4(_ sender: UIButton) {
        if (b4Pressed == false && correctAnswerNumber == 3){
            correctButtonPressed(sender: sender)
        }else if (b4Pressed == false && guessedCorrectAnswer == false){
            wrongButtonPressed(sender: sender)
        }
        b4Pressed = true
    }
    
    func correctButtonPressed(sender: UIButton){
        if currentGameMode == 1{
            progressBar.progress += 0.0167 * 5
            progressBar.setProgress(progressBar.progress, animated: true)
            if(progressBar.progress == 0.0){
                progressBarTimer.invalidate()
                performSegue(withIdentifier: "finished", sender: self)
                //let storyboardController = self.storyboard!.instantiateViewController(withIdentifier: "EndFreePlay")
                //self.present(storyboardController, animated: true, completion: nil)
                //self.dismiss(animated: true, completion: nil)
            }
        }
        guessedCorrectAnswer = true
        sender.backgroundColor = UIColor.green.withAlphaComponent(0.5)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if self.currentGameMode != 2{
                self.askNextQuestion()
            }
        }
    }
    
    func wrongButtonPressed(sender: UIButton){
        if currentGameMode == 1{
            progressBar.progress -= 0.0167 * 5
            progressBar.setProgress(progressBar.progress, animated: true)
            if(progressBar.progress == 0.0){
                progressBarTimer.invalidate()
                performSegue(withIdentifier: "finished", sender: self)
                //let storyboardController = self.storyboard!.instantiateViewController(withIdentifier: "EndFreePlay")
                //self.present(storyboardController, animated: true, completion: nil)
                //self.dismiss(animated: true, completion: nil)
            }
        }
        wrongAnswers += 1
        sender.backgroundColor = UIColor.red.withAlphaComponent(0.5)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //print("this is useless")
        if segue.identifier == "showRankings" {
            if let nextViewController = segue.destination as? RankingsViewController {
                nextViewController.delegate = self
            }
        }
        
        if segue.identifier == "finished" {
            if let nextViewController = segue.destination as? EndgameViewController {
                nextViewController.questionController = self
                nextViewController.settings = settings
                print("Q's Current game mode: \(currentGameMode)")
            }
            
        }
    }
}
