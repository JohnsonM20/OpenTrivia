//
//  PickerAndHighScore.swift
//  Open Trivia
//
//  Created by Matthew Johnson on 4/20/20.
//  Copyright © 2020 Matthew Johnson. All rights reserved.
//

import UIKit

class QuestionTypeAndHighScoreCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var pickerBorder: UIView!
    @IBOutlet weak var scoreView: UIView!
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var score: UILabel!
    
    var dataStore = (UIApplication.shared.delegate as! AppDelegate).data
    var currentRowSelectedInPicker = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        pickerBorder.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        pickerBorder.layer.cornerRadius = 15
        pickerBorder.layer.masksToBounds = true
        scoreView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        scoreView.layer.cornerRadius = 15
        scoreView.layer.masksToBounds = true
        
        picker.dataSource = self
        picker.delegate = self
        picker.selectRow(currentRowSelectedInPicker, inComponent: 0, animated: true)
        
        let defaults = UserDefaults.standard
        score.text = ("High Score for category: \(defaults.string(forKey: "\(dataStore.currentTriviaCategoryID)") ?? "0")")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        currentRowSelectedInPicker = row
        
        if row == 0{
            dataStore.currentTriviaCategoryID = 0
        } else {
            dataStore.currentTriviaCategoryID = dataStore.allTriviaCategories[row-1].id
        }
        
        if dataStore.currentGameMode == GameTypes.joinMultiplayer || dataStore.currentGameMode == GameTypes.startMultiplayer{
            //multiService.send(ObjectAndChangedTo: "\(send.pickerQuestionType)\(questionTypePicker.selectedRow(inComponent: 0))")
        }
        
        let defaults = UserDefaults.standard
        score.text = ("High Score for category: \(defaults.string(forKey: "\(dataStore.currentTriviaCategoryID)") ?? "0")")
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataStore.allTriviaCategories.count+1
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        for category in dataStore.allTriviaCategories {
            category.name = category.name.replacingOccurrences(of: "Entertainment: ", with: "").replacingOccurrences(of: "Science: ", with: "")
        }
        dataStore.allTriviaCategories = dataStore.allTriviaCategories.sorted()
        
        if row == 0{
            return NSAttributedString(string: "All Questions", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        } else {
            return NSAttributedString(string: dataStore.allTriviaCategories[row-1].name, attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        }
    }
    
}
