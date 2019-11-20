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

class ResultArray:Codable {
    var response_code: Int
    var results = [QuestionArray]()
}

class QuestionArray: Codable, CustomStringConvertible {
    var description: String {
        //print(incorrect_answers.count)
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
        print(answers.firstIndex(of: [correct_answer])!)
        return (answers, answerSlot)
    }
    
}


class QuestionViewController: UIViewController {
    
    @IBOutlet var QuestionLabel: UILabel!
    @IBOutlet var Buttons: [UIButton]!
    @IBOutlet var progressBar: UIProgressView!
    
    //var QNumber = Int() //?
    var AnswerNumber = Int()
    var sliderValue = Int()
    var numRoundQuestions = Int()
    var questionsAnswered = Int(0)
    var wrongAnswers = Int(0)
    //
    var response_code: Int = 0
    var results: [QuestionArray] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0...3{
            Buttons[i].layer.cornerRadius = 20
        }

        let urlString = String(format: "https://opentdb.com/api.php?amount=%@", String(getQuestionAmount()))
        let url = URL(string: urlString)
        print("URL: '\(String(describing: url))'")
        
        do{
            let data = try Data(contentsOf:url!)
            let decoder = JSONDecoder()
            let result = try decoder.decode(ResultArray.self, from:data)
            let results = result.results
            let responseCode = result.response_code
            print("Got results: \(results[0])")
            print("Got results: \(responseCode)")
            setDataFromCall(responseCodeFromCall: responseCode, resultsFromCall: results)
            iterateQuestions()
        } catch {
            
        }
        
    }
    
    func setDataFromCall(responseCodeFromCall: Int, resultsFromCall: [QuestionArray]){
        response_code = responseCodeFromCall
        results = resultsFromCall
    }
    
    func getQuestionAmount() -> Int {
        let file = "quizData.txt"
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(file)
            do {
                let selectedQuestions = try String(contentsOf: fileURL, encoding: .utf8)
                numRoundQuestions = Int(selectedQuestions) ?? 10
                print(numRoundQuestions)
            }
            catch {
                numRoundQuestions = 10
            }
        }
        return(numRoundQuestions)
    }
    
    func iterateQuestions(){
        resetButtons()
        if questionsAnswered < getQuestionAmount(){
            progressBar.progress = Float(questionsAnswered)/Float(numRoundQuestions)
            //QuestionLabel.text = results[questionsAnswered].getQuestion()
            QuestionLabel.text = String(cString: results[questionsAnswered].getQuestion(), encoding: .utf8)!
            
            
            print(results[questionsAnswered].getQuestion())
            let answers = results[questionsAnswered].getAnswers()
            
            print("Question Type: ", results[questionsAnswered].getQuestionType())
            
            if results[questionsAnswered].getQuestionType() == "multiple"{
                
                for i in 0..<Buttons.count{
                    print(i)
                    print(String("\(answers.0[i])"))
                    //Buttons[i].setTitle("\(answers.0[i])".removingPercentEncoding, for: UIControl.State.normal)
                    Buttons[i].setTitle("\(answers.0[i][0])", for: UIControl.State.normal)
                }
            } else {
                for i in 0...1{
                    print(i)
                    print("\(answers.0[i])")
                    //let percentString = "hello%20world"
                    //let string = NSString(string: "\(answers.0[i])").removingPercentEncoding!
                    //Buttons[i].setTitle(string)
                    //let blub = "\(answers.0[i])".removingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
                    Buttons[i].setTitle("\(answers.0[i][0])", for: UIControl.State.normal)
                }
                
                for i in 2...3{
                    Buttons[i].isEnabled = false
                    Buttons[i].setTitle("", for: UIControl.State.normal)
                    Buttons[i].backgroundColor = UIColor.clear
                }
            }
            print(answers.0.last!)
            AnswerNumber = answers.1
             
            questionsAnswered += 1
            
        } else {
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "Endgame")
            self.present(controller, animated: true, completion: nil)
        }
        var file = "rightAnswers.txt"
        var text = String(questionsAnswered)

        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(file)
            do {
                try text.write(to: fileURL, atomically: false, encoding: .utf8)
            }
            catch {}
        }
        
        file = "totalClicks.txt"
        text = String(wrongAnswers + questionsAnswered)
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(file)
            do {
                try text.write(to: fileURL, atomically: false, encoding: .utf8)
            }
            catch {}
        }
         
    }
 
    func resetButtons(){
        for i in 0...3{
            if #available(iOS 13.0, *) {
                Buttons[i].backgroundColor = UIColor.tertiarySystemFill
            } else {
                Buttons[i].backgroundColor = UIColor.gray
            }
            Buttons[i].isEnabled = true
        }
    }
    
    @IBAction func Button1(_ sender: UIButton) {
        if AnswerNumber == 0{
            sender.backgroundColor = UIColor.green.withAlphaComponent(0.45)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.iterateQuestions()
            }
        } else{
            wrongAnswers += 1
            sender.backgroundColor = UIColor.red.withAlphaComponent(0.45)
        }
    }
    @IBAction func Button2(_ sender: UIButton) {
        if AnswerNumber == 1{
            sender.backgroundColor = UIColor.green.withAlphaComponent(0.45)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.iterateQuestions()
            }
        }else{
            wrongAnswers += 1
            sender.backgroundColor = UIColor.red.withAlphaComponent(0.45)
        }
    }
    @IBAction func Button3(_ sender: UIButton) {
        if AnswerNumber == 2{
            sender.backgroundColor = UIColor.green.withAlphaComponent(0.45)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.iterateQuestions()
            }
        }else{
            wrongAnswers += 1
            sender.backgroundColor = UIColor.red.withAlphaComponent(0.45)
        }
    }
    @IBAction func Button4(_ sender: UIButton) {
        if AnswerNumber == 3{
            sender.backgroundColor = UIColor.green.withAlphaComponent(0.45)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.iterateQuestions()
            }
        }else{
            wrongAnswers += 1
            sender.backgroundColor = UIColor.red.withAlphaComponent(0.45)
        }
    }
}
