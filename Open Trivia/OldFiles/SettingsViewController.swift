//
//  SettingsViewController.swift
//  FirstQuizGame
//
//  Created by Matthew Johnson on 10/2/19.
//  Copyright © 2019 Matthew Johnson. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var table: UITableView!
    
    @IBOutlet var selectorBackground: UILabel!
    @IBOutlet var questionsAskedLabel: UILabel!
    @IBOutlet var minimumAllowedQuestions: UILabel!
    @IBOutlet var maximumAllowedQuestions: UILabel!
    @IBOutlet var playersConnected: UILabel!
    @IBOutlet var currentSelectedQuestionAmount: UILabel!
    @IBOutlet var questionNumberAskedSlider: UISlider!
    @IBOutlet var directions: UITextView!
    @IBOutlet var questionTypePicker: UIPickerView!
    @IBOutlet var highScore: UILabel!
    var allTriviaCategories: [SingleTriviaCategory] = []
    var currentQuestionAmountAsked = 10
    var currentTriviaCategoryID = 0
    var currentRowSelectedInPicker = 0
    var currentGameMode = 0
    var isGameController = true
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let multiService = MultiplayerService()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Current Game Mode: \(currentGameMode)")
        
        selectorBackground.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        selectorBackground.layer.cornerRadius = 15
        selectorBackground.layer.masksToBounds = true
        
        if currentGameMode == 0{
            questionNumberAskedSlider.isHidden = false
            questionsAskedLabel.isHidden = false
            minimumAllowedQuestions.isHidden = false
            maximumAllowedQuestions.isHidden = false
            highScore.isHidden = true
            selectorBackground.isHidden = false
            playersConnected.isHidden = true
            currentSelectedQuestionAmount.font = currentSelectedQuestionAmount.font.withSize(32)
            questionNumberAskedSlider.value = Float(getQuestionAmountAskedSliderValue()/5)
            currentSelectedQuestionAmount.text = String(Int(questionNumberAskedSlider.value)*5)
            directions.isHidden = true
        } else if currentGameMode == 1{
            questionNumberAskedSlider.isHidden = true
            questionsAskedLabel.isHidden = true
            minimumAllowedQuestions.isHidden = true
            maximumAllowedQuestions.isHidden = true
            playersConnected.isHidden = true
            highScore.isHidden = false
            selectorBackground.isHidden = true
            currentSelectedQuestionAmount.font = currentSelectedQuestionAmount.font.withSize(20)
            currentSelectedQuestionAmount.text = "You have one minute to answer as many questions correctly as you can. You gain 5 seconds for each correct answer, and lose 5 seconds for each wrong answer."
             currentQuestionAmountAsked=50 // maximum without causing error for certain categories
            directions.isHidden = true
        } else if currentGameMode == 2{
            multiService.startService()
            
            multiService.delegate = self
            multiService.send(ObjectAndChangedTo: "test")
            //var isGameController = true
            
            questionNumberAskedSlider.isHidden = false
            questionsAskedLabel.isHidden = false
            minimumAllowedQuestions.isHidden = false
            maximumAllowedQuestions.isHidden = false
            highScore.isHidden = true
            directions.isHidden = false
            selectorBackground.isHidden = false
            playersConnected.isHidden = false
            directions.text = "You are the game controller! Choose game options, wait for all players to join, then press start! Each player gains up to ten points for each correct answer. You may only answer once. You must answer within the alloted 10 seconds. There is a bonus for giving a correct answer quickly. Answers are revealed when all players answer."
            //if directions is for joining players:
            //You have joined a game! Wait for the game controller to choose game options and for other players to join. Each player gains up to ten points for each correct answer. You may only answer once. You must answer within the alloted 10 seconds. There is a bonus for giving a correct answer quickly. Answers are revealed when all players answer.
            playersConnected.backgroundColor = UIColor.black.withAlphaComponent(0.1)
            playersConnected.layer.cornerRadius = 10
            playersConnected.layer.masksToBounds = true
            
            currentSelectedQuestionAmount.font = currentSelectedQuestionAmount.font.withSize(32)
            currentSelectedQuestionAmount.text = String(Int(questionNumberAskedSlider.value)*5)
        }
        
        questionTypePicker.dataSource = self
        questionTypePicker.delegate = self
        questionTypePicker.selectRow(currentRowSelectedInPicker, inComponent: 0, animated: true)
        
    }
    
    func getTriviaCategoriesFromAPI() -> [SingleTriviaCategory]{
        
        let urlString = String(format: "https://opentdb.com/api_category.php")
        let url = URL(string: urlString)
        
        do{
            let data = try Data(contentsOf:url!)//, using: .utf8
            let decoder = JSONDecoder()
            let result = try decoder.decode(TriviaCategoryList.self, from:data)
            allTriviaCategories = result.trivia_categories
            //print(allTriviaCategories)
            //print(allTriviaCategories.count)
        } catch{
            do {
                let path = Bundle.main.path(forResource: "categories", ofType: "txt") // file path for file "data.txt"
                let categoryString = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
                
                //print(categoryString)
                let data = categoryString.data(using: .utf8)
                //print(data)
                let decoder = JSONDecoder()
                let result = try decoder.decode(TriviaCategoryList.self, from:data!)
                allTriviaCategories = result.trivia_categories
            }
            catch {print("error")}

        }
        return allTriviaCategories
    }
    
    func setCurrentGameMode(GameMode: Int){
        if GameMode == 0{
            currentGameMode = 0
        } else if GameMode == 1{
            currentGameMode = 1
        } else if GameMode == 2{
            currentGameMode = 2
        }
    }
    
    func getCurrentGameMode() -> Int{
        print("Current Game Mode:", currentGameMode)
        return currentGameMode
    }
    
    func isPlayerGameController() -> Bool{
        return isGameController
    }
    
    @IBAction func homePushed(_ sender: Any) {
        multiService.stopService()
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func ChangeQuestionNumberSliderActively(_ sender: Any) {
        let questionAmountAsked = Int(questionNumberAskedSlider.value)*5
        currentSelectedQuestionAmount.text = String(questionAmountAsked)
         currentQuestionAmountAsked = questionAmountAsked
        
        if currentGameMode == 2{
            //multiService.send(ObjectAndChangedTo: "\(send.sliderQuestionsAsked)\(questionNumberAskedSlider.value)")
        }
    }
    
    func getQuestionAmountAskedSliderValue() -> Int{
        
        return currentQuestionAmountAsked
    }
    
    @IBAction func playButtonPushed(_ sender: Any) {
         currentRowSelectedInPicker = questionTypePicker.selectedRow(inComponent: 0)
        //print(SettingsViewController.currentRowSelectedInPicker)
        //print(SettingsViewController.currentQuestionAmountAsked)
        if currentGameMode == 2{
            //SettingsViewController.isGameController = true
            //multiService.send(ObjectAndChangedTo: "\(send.isGameMaster)\(false)")
            
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return allTriviaCategories.count+1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        allTriviaCategories = allTriviaCategories.sorted()
        
        if row == 0{
            return NSAttributedString(string: "All Questions", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        } else {
            return NSAttributedString(string: allTriviaCategories[row-1].name.replacingOccurrences(of: "Entertainment: ", with: "").replacingOccurrences(of: "Science: ", with: ""), attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        }
    }
    
    func getCurrentTriviaQuestionID() -> Int {
        return currentTriviaCategoryID
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if row == 0{
            currentTriviaCategoryID = 0
        } else {
            currentTriviaCategoryID = allTriviaCategories[row-1].id
        }
        
        if currentGameMode == 2{
            multiService.send(ObjectAndChangedTo: "\(send.pickerQuestionType)\(questionTypePicker.selectedRow(inComponent: 0))")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settingsDone" {
            //create "destination view controller"
            //set properties on dvc
            
            if let nextViewController = segue.destination as? QuestionViewController {
                //nextViewController.settings = self //Or pass any values
            }
            
        }
    }

}

extension SettingsViewController : MultiplayerServiceDelegate {

    func connectedDevicesChanged(manager: MultiplayerService, connectedDevices: [String]) {
        OperationQueue.main.addOperation {
            //print("testing, connection is connected")
            self.playersConnected.text = " Players Connected: \(connectedDevices)".replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "").replacingOccurrences(of: "\"", with: "")
        }
    }

    func somethingChanged(manager: MultiplayerService, objectAndChangedTo: String) {
        OperationQueue.main.addOperation {
            
            if objectAndChangedTo.hasPrefix("\(send.isGameMaster)"){
                self.multiService.send(ObjectAndChangedTo: "\(send.isGameMaster)\(false)")
                self.isGameController = false
            } else if objectAndChangedTo.hasPrefix("\(send.sliderQuestionsAsked)"){
                let sliderValue = Float(objectAndChangedTo.dropFirst("\(send.sliderQuestionsAsked)".count))
                self.questionNumberAskedSlider.setValue(sliderValue ?? 0.5, animated: true)
                
                let questionAmountAsked = Int(self.questionNumberAskedSlider.value)*5
                self.currentSelectedQuestionAmount.text = String(questionAmountAsked)
                self.currentQuestionAmountAsked = questionAmountAsked
            } else if objectAndChangedTo.hasPrefix("\(send.pickerQuestionType)"){
                let sliderRowNumber = Int(objectAndChangedTo.dropFirst("\(send.pickerQuestionType)".count))
                self.questionTypePicker.selectRow(sliderRowNumber ?? 0, inComponent: 0, animated: true)
            } else {
                NSLog("%@", "Unknown value received: \(objectAndChangedTo)")
            }
        }
    }

}

enum send {
    case sliderQuestionsAsked
    case pickerQuestionType
    case startGame
    case giveQuestionData
    case askNextQuestion
    case sendPlayerAnswerToPlayerController
    case isGameMaster
}
