//
//  SettingsTableViewController.swift
//  Open Trivia
//
//  Created by Matthew Johnson on 4/15/20.
//  Copyright © 2020 Matthew Johnson. All rights reserved.
//

import UIKit

class SettingsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var table: UITableView!
    let gameMode = (UIApplication.shared.delegate as! AppDelegate).data.gameMode

    override func viewDidLoad() {
        super.viewDidLoad()
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
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if gameMode == GameTypes.freePlay { // 4 rows
            if indexPath.row == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.gameDescriptionCell, for: indexPath) as! GameDescriptionCell
                return cell
            } else if indexPath.row == 1{
                let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.questionNumberCell, for: indexPath) as! QuestionNumberCell
                return cell
            } else if indexPath.row == 2{
                let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.questionTypeCell, for: indexPath) as! QuestionTypeCell
                return cell
            } else /*if indexPath.row == 3*/{
                let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.highScoreCell, for: indexPath) as! HighScoreCell
                return cell
            }
        } else { // 3 rows for timed
            if indexPath.row == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.gameDescriptionCell, for: indexPath) as! GameDescriptionCell
                return cell
            } else if indexPath.row == 1{
                let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.questionTypeCell, for: indexPath) as! QuestionTypeCell
                return cell
            } else /*if indexPath.row == 2*/{
                let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.highScoreCell, for: indexPath) as! HighScoreCell
                return cell
            }
        }
        //cell.questionNumberAsked.titleForSegment(at: cell.questionNumberAsked.selectedSegmentIndex)
        //cell.nameLabel.text = searchResult.name cell.artistNameLabel.text = searchResult.artistName
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CellGameModeSections.getNumberOfRowsInSection(gameMode: gameMode)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @IBAction func homePushed(_ sender: Any) {
        //multiService.stopService()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func playButtonPushed(_ sender: Any) {
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

struct TableView {
    struct CellIdentifiers {
        static let questionNumberCell = "MyQuestionNumberCell"
        static let questionTypeCell = "MyQuestionTypeCell"
        static let gameDescriptionCell = "MyGameDescriptionCell"
        static let highScoreCell = "MyHighScoreCell"
    }
}
