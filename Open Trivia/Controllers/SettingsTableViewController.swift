//
//  SettingsTableViewController.swift
//  Open Trivia
//
//  Created by Matthew Johnson on 4/15/20.
//  Copyright © 2020 Matthew Johnson. All rights reserved.
//

import UIKit
import AVFoundation

class SettingsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet var table: UITableView!
    let dataStore = (UIApplication.shared.delegate as! AppDelegate).data
    var isLoading = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        playButton.backgroundColor = UIColor(red: 129/255.0, green: 204/255.0, blue: 197/255.0, alpha: 1.0)
        playButton.layer.shadowColor = UIColor(red: 90/255.0, green: 187/255.0, blue: 181/255.0, alpha: 1.0).cgColor
        playButton.layer.shadowOffset = CGSize(width: 0.0, height: 8.0)
        playButton.layer.shadowOpacity = 1.0
        playButton.layer.cornerRadius = 20.0
        playButton.layer.shadowRadius = 0.0
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor(red: 0/255.0, green: 180/255.0, blue: 106/255.0, alpha: 1.0).cgColor, UIColor(red: 63/255.0, green: 161/255.0, blue: 200/255.0, alpha: 1.0).cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        dataStore.resetData()
        
        table.separatorStyle = UITableViewCell.SeparatorStyle.none
        table.dataSource = self
        table.delegate = self
        
        let numberCellNib = UINib(nibName: "QuestionNumber", bundle: nil)
        table.register(numberCellNib, forCellReuseIdentifier: TableView.CellIdentifiers.questionNumberCell)
        let typeCellNib = UINib(nibName: "QuestionType", bundle: nil)
        table.register(typeCellNib, forCellReuseIdentifier: TableView.CellIdentifiers.questionTypeCell)
        let descriptionCellNib = UINib(nibName: "GameDescription", bundle: nil)
        table.register(descriptionCellNib, forCellReuseIdentifier: TableView.CellIdentifiers.gameDescriptionCell)
        let highScoreCellNib = UINib(nibName: "HighScore", bundle: nil)
        table.register(highScoreCellNib, forCellReuseIdentifier: TableView.CellIdentifiers.highScoreCell)
        let loadingCellNib = UINib(nibName: "Loading", bundle: nil)
        table.register(loadingCellNib, forCellReuseIdentifier: TableView.CellIdentifiers.loadingCell)
        let multiCell = UINib(nibName: "QuestionTypeAndHighScore", bundle: nil)
        table.register(multiCell, forCellReuseIdentifier: TableView.CellIdentifiers.TypeAndScoreCell)
        
        centerTableContentsIfNeeded()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoading {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.loadingCell, for: indexPath)
            let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
            spinner.startAnimating()
            return cell
        } else if dataStore.currentGameMode == GameTypes.freePlay { // 3 rows
            if indexPath.row == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.gameDescriptionCell, for: indexPath) as! GameDescriptionCell
                return cell
            } else if indexPath.row == 1{
                let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.questionNumberCell, for: indexPath) as! QuestionNumberCell
                return cell
            } else /*if indexPath.row == 2*/{
                let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.questionTypeCell, for: indexPath) as! QuestionTypeCell
                return cell
            }
        } else { // 3 rows for timed
            if indexPath.row == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.gameDescriptionCell, for: indexPath) as! GameDescriptionCell
                return cell
            } else /*if indexPath.row == 1*/{
                let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.TypeAndScoreCell, for: indexPath) as! QuestionTypeAndHighScoreCell
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
            return 1
        } else {
            return CellGameModeSections.getNumberOfRowsInSection(gameMode: dataStore.currentGameMode)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func centerTableContentsIfNeeded() {
        let screenSize = UIScreen.main.bounds
        let screenHeight = screenSize.height
        //let screenWidth = screenSize.height
        //print(screenHeight)
        let totalTableHeight = table.bounds.height
        //print(totalTableHeight)
        let contentHeight = 550.0//table.contentSize.height
        //print(contentHeight)
        //let contentWidth = table.frame.size.width//table.contentSize.width.
        //print(contentWidth)
        let contentCanBeCentered = contentHeight < Double(totalTableHeight)
        let heightAdded = screenHeight/2-CGFloat(contentHeight)/1.5
        if contentCanBeCentered && heightAdded > 0 {
            table.contentInset = UIEdgeInsets(top: heightAdded, left: 0, bottom: 0, right: 0);
            print(heightAdded)
        }
    }
    
    @IBAction func homePushed(_ sender: Any) {
        dataStore.playTinkSound()
        
        //multiService.stopService()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func playButtonPushed(_ sender: UIButton) {
        dataStore.playTinkSound()
        
        sender.isEnabled = false
        isLoading = true
        table.reloadData()
        
        if dataStore.currentGameMode != GameTypes.freePlay{
            dataStore.totalAmountOfQuestions = 50
        }
        
        dataStore.getTriviaQuestionsFromAPI(){
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "settingsDone", sender:self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "settingsDone" {
            //if let nextViewController = segue.destination as? QuestionViewController {
                //nextViewController.settings = self //Or pass any values
            //}
        }
    }
}

struct TableView {
    struct CellIdentifiers {
        static let questionNumberCell = "MyQuestionNumberCell"
        static let questionTypeCell = "MyQuestionTypeCell"
        static let gameDescriptionCell = "MyGameDescriptionCell"
        static let highScoreCell = "MyHighScoreCell"
        static let loadingCell = "MyLoadingCell"
        static let TypeAndScoreCell = "MyMultiCell"
    }
}
