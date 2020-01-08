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

class ResultArray:Codable
{
    var response_code: Int
    var results = [QuestionArray]()
}

class QuestionArray: Codable, CustomStringConvertible {
    var description: String {
        return "Category: \(category ?? "None"), Type: \(type), Difficulty: \(difficulty ?? "None"), Question: \(question), Answer: \(correct_answer ), Incorrect Answers: \(incorrect_answers)"
    }
    
    var category: String? = ""
    var type: String = ""
    var difficulty: String? = ""
    var question: String = ""
    var correct_answer: String = ""
    var incorrect_answers = [] as [String]
    
    func getQuestion() -> String{
        return (question)
    }
    
    func getQuestionType() -> String {
        return (type)
    }

    func getAnswers() -> ([Array<String>], Int){
        var answers = [Array<String>]()
        answers.append([correct_answer])
        for i in 0..<incorrect_answers.count{
            answers.append([incorrect_answers[i]])
        }
        answers = answers.shuffled()
        print("correct answer:", answers.firstIndex(of: [correct_answer])!)
        answers.append(["\(answers.firstIndex(of: [correct_answer])!)"])
        let answerSlot = answers.firstIndex(of: [correct_answer])!
        //print(answers.firstIndex(of: [correct_answer])!)
        return (answers, answerSlot)
    }
    
}


class QuestionViewController: UIViewController {
    
    @IBOutlet var questionAskedLabel: UILabel!
    @IBOutlet var answerButtons: [UIButton]!
    @IBOutlet var progressBar: UIProgressView!
    var correctAnswerNumber = Int()
    var sliderPercentDoneValue = Int()
    var numRoundQuestions = Int()
    static var questionsAnswered = Int()
    static var wrongAnswers = Int()
    var response_code: Int = 0
    var resultsFromAPI: [QuestionArray] = []
    static var currentGameMode = 0 // 0=FreePlay,1=Timed,2=Mutiplayer
    
    //for each round
    var b1Pressed = false
    var b2Pressed = false
    var b3Pressed = false
    var b4Pressed = false
    var guessedCorrectAnswer = false
    //
    
    static var progressBarTimer: Timer!
    static var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set number of questions answered back to 0
        QuestionViewController.questionsAnswered = 0
        
        progressBar.transform = progressBar.transform.scaledBy(x: 1, y: 5)
        progressBar.layer.cornerRadius = 10
        progressBar.clipsToBounds = true
        progressBar.layer.sublayers![1].cornerRadius = 10
        progressBar.subviews[1].clipsToBounds = true
        
        QuestionViewController.currentGameMode = SettingsViewController.getCurrentGameMode()
        if (QuestionViewController.currentGameMode == 0){
            progressBar.progress = Float(QuestionViewController.questionsAnswered)/Float(numRoundQuestions)
        } else if (QuestionViewController.currentGameMode == 1){
            progressBar.progress = 1.0
            //progressBarTimer.invalidate()
            QuestionViewController.progressBarTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateProgressView), userInfo: nil, repeats: true)
            //progressBarTimer.fire()
        }
        
        //make buttons rounded
        for i in 0...3{
            answerButtons[i].layer.cornerRadius = 20
        }

        let urlString = String(format:"https://opentdb.com/api.php?amount=\(getQuestionAmount())&category=\(getCategory())")
        
        let url = URL(string: urlString)
        //print("URL: '\(String(describing: url))'")
        
        do{
            let JSONdata = try Data(contentsOf:url!)//, using: .utf8
            let decoder = JSONDecoder()
            let decodedJSON = try decoder.decode(ResultArray.self, from:JSONdata)
            let results = decodedJSON.results
            let responseCode = decodedJSON.response_code
            setDataFromCall(responseCodeFromCall: responseCode, resultsFromCall: results)
            askNextQuestion()
        } catch {}
    }
    
    //For Timed mode timer
    @objc func updateProgressView(){
        progressBar.progress -= 0.0167
        progressBar.setProgress(progressBar.progress, animated: true)
        if(progressBar.progress == 0.0)
        {
            QuestionViewController.progressBarTimer.invalidate()
            let storyboardController = self.storyboard!.instantiateViewController(withIdentifier: "EndFreePlay")
            self.present(storyboardController, animated: true, completion: nil)
        }
    }
    
    func getCategory() -> String{
        return String(SettingsViewController.getCurrentTriviaQuestionID())
    }
    
    static func updateGameMode(gameMode: Int){
        QuestionViewController.currentGameMode = gameMode
    }
    
    func getQuestionAmount() -> Int {
        //sets progress bar total questions asked
        numRoundQuestions = SettingsViewController.getQuestionAmountAskedSliderValue()
        return SettingsViewController.getQuestionAmountAskedSliderValue()
    }
    
    func setDataFromCall(responseCodeFromCall: Int, resultsFromCall: [QuestionArray]){
        response_code = responseCodeFromCall
        resultsFromAPI = resultsFromCall
    }
    
    func askNextQuestion(){
        resetButtons()
        if QuestionViewController.questionsAnswered < getQuestionAmount(){
            if (QuestionViewController.currentGameMode == 0){
                progressBar.progress = Float(QuestionViewController.questionsAnswered)/Float(numRoundQuestions)
            } else if (QuestionViewController.currentGameMode == 1){
                //progressBar.progress = 0.5
            }
            
            
            questionAskedLabel.text = resultsFromAPI[QuestionViewController.questionsAnswered].getQuestion().replacingOccurrences(of: "&quot;", with: "'").replacingOccurrences(of:"&#039;", with:"'").replacingOccurrences(of:"&eacute;", with:"é").replacingOccurrences(of:"&amp;", with:"&")
            
            //print(resultsFromAPI[QuestionViewController.questionsAnswered].getQuestion())
            let answers = resultsFromAPI[QuestionViewController.questionsAnswered].getAnswers()
            
            //print("Question Type: ", resultsFromAPI[QuestionViewController.questionsAnswered].getQuestionType())
            
            if resultsFromAPI[QuestionViewController.questionsAnswered].getQuestionType() == "multiple"{
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
            QuestionViewController.questionsAnswered += 1
            
        } else {
            let storyboardController = self.storyboard!.instantiateViewController(withIdentifier: "EndFreePlay")
            self.present(storyboardController, animated: true, completion: nil)
        }
         
    }
    
    static func getRightAnswersAndQuestionsAnswered() -> (Int, Int){
        return (questionsAnswered, questionsAnswered+wrongAnswers)

    }
    
    static func resetVarsForNextRound(){
        questionsAnswered=0
        wrongAnswers=0
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
        if correctAnswerNumber == 0{
            //
            progressBar.progress += 0.0167 * 5
            progressBar.setProgress(progressBar.progress, animated: true)
            if(progressBar.progress == 0.0)
            {
                QuestionViewController.progressBarTimer.invalidate()
                let storyboardController = self.storyboard!.instantiateViewController(withIdentifier: "EndFreePlay")
                self.present(storyboardController, animated: true, completion: nil)
            }
            //
            guessedCorrectAnswer = true
            sender.backgroundColor = UIColor.green.withAlphaComponent(0.5)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.askNextQuestion()
            }
        } else if (b1Pressed == false && guessedCorrectAnswer == false){
            //
            progressBar.progress -= 0.0167 * 5
            progressBar.setProgress(progressBar.progress, animated: true)
            if(progressBar.progress == 0.0)
            {
                QuestionViewController.progressBarTimer.invalidate()
                let storyboardController = self.storyboard!.instantiateViewController(withIdentifier: "EndFreePlay")
                self.present(storyboardController, animated: true, completion: nil)
            }
            //
            QuestionViewController.wrongAnswers += 1
            sender.backgroundColor = UIColor.red.withAlphaComponent(0.5)
            b1Pressed = true
        }
    }
    @IBAction func Button2(_ sender: UIButton) {
        if correctAnswerNumber == 1{
            //
            progressBar.progress += 0.0167 * 5
            progressBar.setProgress(progressBar.progress, animated: true)
            if(progressBar.progress == 0.0)
            {
                QuestionViewController.progressBarTimer.invalidate()
                let storyboardController = self.storyboard!.instantiateViewController(withIdentifier: "EndFreePlay")
                self.present(storyboardController, animated: true, completion: nil)
            }
            //
            guessedCorrectAnswer = true
            sender.backgroundColor = UIColor.green.withAlphaComponent(0.5)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.askNextQuestion()
            }
        }else if (b2Pressed == false && guessedCorrectAnswer == false){
            //
            progressBar.progress -= 0.0167 * 5
            progressBar.setProgress(progressBar.progress, animated: true)
            if(progressBar.progress == 0.0)
            {
                QuestionViewController.progressBarTimer.invalidate()
                let storyboardController = self.storyboard!.instantiateViewController(withIdentifier: "EndFreePlay")
                self.present(storyboardController, animated: true, completion: nil)
            }
            //
            QuestionViewController.wrongAnswers += 1
            sender.backgroundColor = UIColor.red.withAlphaComponent(0.5)
            b2Pressed = true
        }
    }
    @IBAction func Button3(_ sender: UIButton) {
        if correctAnswerNumber == 2{
            //
            progressBar.progress += 0.0167 * 5
            progressBar.setProgress(progressBar.progress, animated: true)
            if(progressBar.progress == 0.0)
            {
                QuestionViewController.progressBarTimer.invalidate()
                let storyboardController = self.storyboard!.instantiateViewController(withIdentifier: "EndFreePlay")
                self.present(storyboardController, animated: true, completion: nil)
            }
            //
            guessedCorrectAnswer = true
            sender.backgroundColor = UIColor.green.withAlphaComponent(0.5)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.askNextQuestion()
            }
        }else if (b3Pressed == false && guessedCorrectAnswer == false){
            //
            progressBar.progress -= 0.0167 * 5
            progressBar.setProgress(progressBar.progress, animated: true)
            if(progressBar.progress == 0.0)
            {
                QuestionViewController.progressBarTimer.invalidate()
                let storyboardController = self.storyboard!.instantiateViewController(withIdentifier: "EndFreePlay")
                self.present(storyboardController, animated: true, completion: nil)
            }
            //
            QuestionViewController.wrongAnswers += 1
            sender.backgroundColor = UIColor.red.withAlphaComponent(0.5)
            b3Pressed = true
        }
    }
    @IBAction func Button4(_ sender: UIButton) {
        if correctAnswerNumber == 3{
            //
            progressBar.progress += 0.0167 * 5
            progressBar.setProgress(progressBar.progress, animated: true)
            if(progressBar.progress == 0.0)
            {
                QuestionViewController.progressBarTimer.invalidate()
                let storyboardController = self.storyboard!.instantiateViewController(withIdentifier: "EndFreePlay")
                self.present(storyboardController, animated: true, completion: nil)
            }
            //
            guessedCorrectAnswer = true
            sender.backgroundColor = UIColor.green.withAlphaComponent(0.5)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.askNextQuestion()
            }
        }else if (b4Pressed == false && guessedCorrectAnswer == false){
            //
            progressBar.progress -= 0.0167 * 5
            progressBar.setProgress(progressBar.progress, animated: true)
            if(progressBar.progress == 0.0)
            {
                QuestionViewController.progressBarTimer.invalidate()
                let storyboardController = self.storyboard!.instantiateViewController(withIdentifier: "EndFreePlay")
                self.present(storyboardController, animated: true, completion: nil)
            }
            //
            QuestionViewController.wrongAnswers += 1
            sender.backgroundColor = UIColor.red.withAlphaComponent(0.5)
            b4Pressed = true
        }
    }
}

